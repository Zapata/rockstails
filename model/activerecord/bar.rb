class Bar < ActiveRecord::Base
  validates :name, length: { maximum: 100 }, presence: true, uniqueness: { case_sensitive: false }

  has_and_belongs_to_many :ingredients

  default_scope { includes(:ingredients) }

  def ingredient_names
    return ingredients.collect { |i| i.name }
  end
  
  def add(ingredient_name)
    ingredients << Ingredient.where(name: ingredient_name)
  end
end