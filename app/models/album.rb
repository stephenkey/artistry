class Album < ApplicationRecord

  belongs_to :artist, counter_cache: true

  has_many :tracks
  has_many :images
  has_many :libraries
  has_many :users, through: :libraries

  validates :name,     presence: true
  validates :artist_id, presence: true

  def year
    published.present? ? published.to_time.strftime("%Y").to_i : nil
  end

  def self.search(q)
    return [] unless q.present?
    begin
      response = RestClient.get 'http://ws.audioscrobbler.com/2.0/', {
        params: {
          api_key: ENV['LAST_FM_API_KEY'],
          format: 'json',
          method: 'album.search',
          album: URI.encode(q, /\W/)
        }
      }
    rescue RestClient::Unauthorized, RestClient::Forbidden => err
      puts 'Access denied'
      return nil
    else
      json_response = JSON.parse(response)
      return json_response.dig('results', 'albummatches', 'album')
    end
  end

  def self.lookup(artist_name, album_name)
    return [] unless artist_name.present? and album_name.present?
    begin
      response = RestClient.get 'http://ws.audioscrobbler.com/2.0/', {
        params: {
          api_key: ENV['LAST_FM_API_KEY'],
          format: 'json',
          method: 'album.getInfo',
          artist: artist_name,
          album: album_name
        }
      }
    rescue RestClient::Unauthorized, RestClient::Forbidden => err
      puts 'Access denied'
      return nil
    else
      json_response = JSON.parse(response)
      puts 'Lookup response'
      puts json_response
      puts json_response.dig('album')
      return json_response.dig('album')
    end
  end

  def self.import(album_data)
    return false unless album_data.key?('artist') && album_data.key?('name')

    artist = Artist.find_or_create_by(name: album_data['artist'])

    album = artist.albums.new(name: album_data['name'])
    album.published = album_data.dig('wiki', 'published')
    album.last_fm_url = album_data.dig('url')
    album.save!

    if album_data.key?('image')
      album_data['image'].each do |i|
        album.images.create(url: i['#text']) if i.key?('#text') and i['#text'].present?
      end
    end

    if album_data.dig('tracks', 'track')
      album_data['tracks']['track'].each do |t|
        track = album.tracks.new(name: t['name'])
        track.seconds = t.dig('duration')
        track.last_fm_url = t.dig('url')
        track.order = t.dig('@attr', 'rank')
        track.save!
      end
    end

    album
  end

  def self.find_and_assign(artist_name, album_name, user_id)
    puts 'Running find and assign'
    user = User.find(user_id)
    artist = Artist.find_or_create_by(name: artist_name)
    album = artist.albums.find_by(name: album_name)
    unless album
      puts 'Need to import album'
      album_data = self.lookup(artist_name, album_name)
      puts album_data
      album = self.import(album_data) if album_data
    end
    user.albums << album if album
  end

end
