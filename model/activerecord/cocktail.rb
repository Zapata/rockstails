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
  
  default_scope { includes(:ingredients) }
  
  def ingredient_names
    return ingredients.collect { |i| i.name }
  end
  
  def self.all_as_yaml
    cocktails = []
    Cocktail.all.includes(recipe_steps: [:ingredient]).find_each do |db_cocktail|
      cocktails << db_cocktail.as_yaml(as_hash: true, except: [:id, :created_at, :updated_at],
        include: {
          recipe_steps: {
            except: [:id, :cocktail_id, :ingredient_id, :position],
            methods: [:ingredient_name]
          }
        })
    end
    return cocktails
  end
  
  def from_yaml(yaml_hash)
    yaml_recipe_steps = yaml_hash.delete('recipe_steps')
    self.attributes = yaml_hash
    yaml_recipe_steps.each_with_index do |step, index|
      ingredient = Ingredient.where(name: step['ingredient_name']).first_or_create
      recipe_steps << RecipeStep.new(position: index, amount: step['amount'], doze: step['doze'], ingredient: ingredient)
    end
    return self
  end
end