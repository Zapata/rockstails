class Cocktail < ActiveRecord::Base
  has_many :compositions, :dependent => :delete_all
  has_many :ingredients, :through => :compositions
end
