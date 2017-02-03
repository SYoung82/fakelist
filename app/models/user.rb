class User < ActiveRecord::Base
  has_many :ads
  has_many :genres, through: :songs
  has_secure_password
end
