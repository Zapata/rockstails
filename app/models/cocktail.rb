class Cocktail
  include MongoMapper::Document

  key :name,  String, :require => true
  many :ingredients

  def copy_from dirty_cocktail
    # properties
    @name = dirty_cocktail.name

    # ingredients
    dirty_cocktail.ingredients.each do |dirty_ingredient|
      # dirty cocktail ingredients : [ amount, doze, ingredient_name ]
      existing_ingredient = Ingredient.first( :name => dirty_ingredient[2] )
      # TODO: whis is @ingredients nil?
      if(existing_ingredient)
        @ingredients << existing_ingredient
      else
        @ingredients << Ingredient.new.copy_from(dirty_ingredient)
      end
    end
    return self
  end
end
