class Ingredient
  include MongoMapper::Document

  key :name,  String, :require => true

  def copy_from ingredient
    # dirty cocktail ingredients : [ amount, doze, ingredient_name ]
    # convert it from yaml's iso to mongo's utf-8
    @name = Iconv.conv('utf-8', 'ISO-8859-1', ingredient[2])
  end
end
