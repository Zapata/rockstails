class Ingredient
  include MongoMapper::Document

  key :name, String, :require => true
  key :diffords_name, String
end
