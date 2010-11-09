class Ingredient < ActiveRecord::Base
  has_many :compositions, :dependent => :delete_all
end
