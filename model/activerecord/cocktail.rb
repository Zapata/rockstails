class Cocktail < ActiveRecord::Base
  validates :name, length: { maximum: 100 }, presence: true, uniqueness: { case_sensitive: false }
  validates :method, presence: true
  validates :rate, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0 }
  validates :aka, length: { maximum: 100 }
  validates :variant, length: { maximum: 500 }
  validates :garnish, length: { maximum: 500 }
  validates :glass, length: { maximum: 250 }
  validates :source, length: { maximum: 250 }, presence: true

  has_many :recipe_steps, inverse_of: :cocktail, autosave: true, dependent: :destroy
  validates_associated :recipe_steps
  
  has_many :ingredients, through: :recipe_steps
  
  def ingredient_names
    return ingredients.collect { |i| i.name }
  end
end