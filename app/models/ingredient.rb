class Ingredient
  include MongoMapper::Document

  key :name,  String, :require => true

  def copy_from ingredient
    # dirty cocktail ingredients : [ amount, doze, ingredient_name ]
    @name = ingredient[2]
  end
end
