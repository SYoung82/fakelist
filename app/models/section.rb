class Section < ActiveRecord::Base
  has_many :ads
  has_many :users, through: :ads

  def slug
    self.name
  end

  def self.find_by_slug(slug)
    User.find_by(:name => slug)
  end
end
