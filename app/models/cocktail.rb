class Cocktail
  include MongoMapper::Document

  key :name,  String, :require => true
  many :compositions

  def copy_from dirty_cocktail
    # properties
    @name = dirty_cocktail.name

    # ingredients
    copy_ingredients_from dirty_cocktail 
    return self
  end

private
  def copy_ingredients_from dirty_cocktail
    dirty_cocktail.ingredients.each do |dirty_ingredient|
      # dirty cocktail ingredients : [ amount, doze, ingredient_name ]
      # convert it from yaml's iso to mongo's utf-8
      amount = dirty_ingredient[0]
      doze = dirty_ingredient[1]
      ingredient_name = Iconv.conv('utf-8', 'ISO-8859-1', dirty_ingredient[2])

      existing_ingredient = Ingredient.first( :name => ingredient_name )

      if(existing_ingredient)
        ingredient = existing_ingredient
      else
        ingredient = Ingredient.new(:name => ingredient_name)
        ingredient.save
      end

      # use self to use MongoMapper interceptors
      self.compositions << Composition.new(
        :amount => amount,
        :doze => doze,
        :ingredient => ingredient
      )
    end
  end

end
