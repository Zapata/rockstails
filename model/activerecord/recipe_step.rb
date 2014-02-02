class RecipeStep < ActiveRecord::Base
  validates :position, presence: true
  validates :amount, presence: true, length: { maximum: 10 }
  validates :doze, presence: true, length: { maximum: 30 } # FIXME: Have an enum here.

  belongs_to :cocktail, inverse_of: :recipe_steps, touch: true
  belongs_to :ingredient
  
  validates :ingredient, uniqueness: { scope: :cocktail }
    
  def ingredient_name
    return ingredient.name
  end
end