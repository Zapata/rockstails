class Cocktail
  include MongoMapper::Document

  key :name,  String, :require => true, :index => true
  key :glass, String
  key :aka, String
  key :comment, String
  key :origin, String
  key :source, String
  key :method, String
  key :rate, Float, :index => true
  key :garnish, String
  key :variant, String

  many :compositions

  def copy_from dirty_cocktail
    # properties
    @name = to_utf8 dirty_cocktail.name
    @glass = to_utf8 dirty_cocktail.glass
    @method = to_utf8 dirty_cocktail.method
    @rate = dirty_cocktail.rate
    @garnish = dirty_cocktail.garnish
    @aka = to_utf8 dirty_cocktail.infos['AKA']
    @comment = to_utf8 dirty_cocktail.infos['Comment']
    @origin = to_utf8 dirty_cocktail.infos['Origin']
    @source = to_utf8 dirty_cocktail.infos['source']
    @variant = to_utf8 dirty_cocktail.infos['variant']

    # ingredients
    copy_ingredients_from dirty_cocktail 
    return self
  end
  
  def compo_summary
    "#{compositions[0..2].join(', ')} #{compositions.length > 2 ? '...' : ''}"
  end

private
  def to_utf8 iso
    Iconv.conv('utf-8', 'ISO-8859-1', iso)
  end

  def copy_ingredients_from dirty_cocktail
    dirty_cocktail.ingredients.each do |dirty_ingredient|
      # dirty cocktail ingredients : [ amount, doze, ingredient_name ]
      # convert it from yaml's iso to mongo's utf-8
      amount = dirty_ingredient[0]
      doze = dirty_ingredient[1]
      ingredient_name = to_utf8 dirty_ingredient[2]

      # "dirty cocktails" come from difford's cocktails
      existing_ingredient = Ingredient.first( :diffords_name => ingredient_name )

      if(existing_ingredient)
        ingredient = existing_ingredient
      else
        ingredient = Ingredient.new(:name => ingredient_name, :diffords_name => ingredient_name)
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
