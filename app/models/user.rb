class User < ActiveRecord::Base
  has_many :ads
  has_secure_password
end
