module AlbumsHelper
  def cover_art(image=[])
    image_object = image.find{|o| o['size'] == 'extralarge' and o['#text'].present? }
    url = image_object['#text'] if image_object
    url ||= 'https://lastfm-img2.akamaized.net/i/u/174s/c6f59c1e5e7240a4c0d427abd71f3dbb'
  end
end
