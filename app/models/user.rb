class User < ActiveRecord::Base
  has_many :ads
  has_many :sections, through: :ads
  has_secure_password
end
