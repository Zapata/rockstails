class Bar < ActiveRecord::Base
  validates :name, length: { maximum: 100 }, presence: true, uniqueness: { case_sensitive: false }

  has_and_belongs_to_many :ingredients
  
  def ingredient_names
    return ingredients.collect { |i| i.name }
  end
end