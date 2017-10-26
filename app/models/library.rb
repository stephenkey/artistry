class Library < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :album

  validates :user_id,  presence: true
  validates :album_id, presence: true

  aasm column: 'state', whiny_transitions: false do
    state :new, :initial => true
    state :refurbished
    state :like_new
    state :good
    state :acceptable
    state :unacceptable

    event :refurbish do
      transitions from: [:like_new, :good, :acceptable, :unacceptable], to: :refurbished
    end

    event :break do
      transitions from: [:new, :refurbished, :like_new, :good, :acceptable], to: :unacceptable
    end
  end

end
