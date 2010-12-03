class Ingredient
  include MongoMapper::Document

  key :name,  String, :require => true
end
