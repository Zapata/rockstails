
class DirtyCocktail
  attr_accessor :name, :garnish, :glass, :method
  attr_accessor :ingredients, :infos, :rate, :source
  
  IDX_AMOUNT = 0
  IDX_DOZE = 1
  IDX_INGREDIENT = 2
  
  def initialize
    @infos = {}
    @ingredients = []
  end  
  
  def get_ingredients()
    ingredients.collect { |i| i[IDX_INGREDIENT]}
  end
end