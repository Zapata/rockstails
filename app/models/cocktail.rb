class Cocktail
  include MongoMapper::Document

  key :name,  String, :require => true
  many :ingredients

  def copy_from dirty_cocktail
    # properties
    @name = dirty_cocktail.name

    # ingredients
    # TODO: whis is @ingredients nil? for the moment deactivated
    copy_ingredients_from dirty_cocktail 
    return self
  end

private
  def copy_ingredients_from dirty_cocktail
    dirty_cocktail.ingredients.each do |dirty_ingredient|
      # dirty cocktail ingredients : [ amount, doze, ingredient_name ]
      existing_ingredient = Ingredient.first( :name => dirty_ingredient[2] )
      
      # use self to use MongoMapper interceptors
      if(existing_ingredient)
        self.ingredients << existing_ingredient
      else
        ing = Ingredient.new
        ing.copy_from(dirty_ingredient)
        self.ingredients << ing
      end
    end
  end

end
