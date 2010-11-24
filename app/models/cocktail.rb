class Cocktail
  include MongoMapper::Document

  key :name,  String, :require => true
  many :ingredients

  def copy_from cocktail
    @name = cocktail.name
    return self
  end
end
