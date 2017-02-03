class Genre < ActiveRecord::Base
  has_many :ads
  has_many :users, through: :ads
end
