class User < ActiveRecord::Base
  has_many :ads
  has_many :sections, through: :ads
  has_secure_password

  validates :email, :username, presence: true
  validates :email, :username, uniqueness: true
end
