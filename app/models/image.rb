class Image < ApplicationRecord

  belongs_to :album

  validates :album_id, presence: true
  validates :url,      presence: true

end
