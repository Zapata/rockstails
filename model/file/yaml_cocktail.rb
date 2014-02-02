require 'hashie'

class YamlCocktail < Hashie::Mash
  def ingredient_names
    return recipe_steps.collect { |s| s.ingredient_name }
  end
end