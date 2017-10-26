class Track < ApplicationRecord

  belongs_to :album

  validates :album_id, presence: true
  validates :name,     presence: true

  def self.popular
    begin
      response = RestClient.get 'http://ws.audioscrobbler.com/2.0/', {
        params: {
          api_key: ENV['LAST_FM_API_KEY'],
          format: 'json',
          method: 'chart.gettoptracks'
        }
      }
    rescue RestClient::Unauthorized, RestClient::Forbidden => err
      puts 'Access denied'
      return nil
    else
      json_response = JSON.parse(response)
      return json_response.dig('tracks', 'track')
    end
  end

end
