class Track < ApplicationRecord

  belongs_to :album

  validates :album_id, presence: true
  validates :title, presence: true

end
