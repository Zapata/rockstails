class Cocktail
  include MongoMapper::Document

  key :name,  String, :require => true
  many :ingredients
end
