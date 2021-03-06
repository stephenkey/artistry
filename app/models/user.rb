class User < ApplicationRecord

  has_many :libraries
  has_many :albums, through: :libraries

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name,  presence: true
  validates :email, presence: true

end
