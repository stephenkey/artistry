class Artist < ApplicationRecord
  require 'csv'
  
  has_many :albums
  
  validates :name, presence: true
  
  def albums_years
    years = self.albums.map {|a| a.year if a.published.present? }.compact
    years.any? ? "#{years.min}-#{years.max}" : 'N/A'
  end
  
  def common_words
    string = ''
    self.albums.each do |album|
      album.tracks.each do |track|
        string += " #{track.name}"
      end
    end
    words = string.split(' ').reject(&:empty?)
    counts = words.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    max = counts.values.max
    counts.select { |k,v| v == max }.keys.to_sentence
  end

  def export_values
    values_array = [name]
    values_array.push(self.albums.length)
    values_array.push(self.albums_years)
    values_array.push(self.common_words)
  end
  
  def self.export_columns
    ['name', '# of Albums', 'Years', 'Common Words']
  end
  
  def self.to_csv(options = {})
    artists = self.includes(albums: [:images, :tracks]).all
    CSV.generate(options) do |csv|
      csv << export_columns
      artists.each do |artist|
        csv << [artist.name, artist.albums.length, artist.albums_years, artist.common_words]
      end
    end
  end
  
end
