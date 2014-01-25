require 'set'
require_relative '../db/database'
require_relative '../model/file/dirty_cocktail'
require_relative '../model/activerecord/cocktail'
require_relative '../model/activerecord/ingredient'
require_relative '../model/activerecord/recipe_step'
require_relative '../model/activerecord/active_record_db'


def import_cocktails 
  dynamic_fields = Set.new
  Cocktail.delete_all
  
  Dir['datas/cocktails/*.yml'].each do |f|
    yml_cocktail = YAML::load_file(f)
    puts "Processing #{yml_cocktail.name}..."
    Cocktail.create do |db_cocktail|
      db_cocktail.name = yml_cocktail.name
      db_cocktail.glass = yml_cocktail.glass
      db_cocktail.garnish = yml_cocktail.garnish
      db_cocktail.rate = yml_cocktail.rate
      db_cocktail.method = yml_cocktail.method
      db_cocktail.origin = yml_cocktail.infos['Origin']
      db_cocktail.comment = yml_cocktail.infos['Comment']
      db_cocktail.source = yml_cocktail.infos['source']
      db_cocktail.aka = yml_cocktail.infos['AKA']
      db_cocktail.variant = yml_cocktail.infos['Variant']
      dynamic_fields.merge(yml_cocktail.infos.keys)
      yml_cocktail.ingredients.each_with_index do |arr, index|
          name = arr[2]
          ingredient = Ingredient.find_by(name: name)
          ingredient = Ingredient.create(name: name) if ingredient.nil?
          db_cocktail.recipe_steps << RecipeStep.new(position: index, amount: arr[0], doze: arr[1], ingredient: ingredient)
      end
    end
    
  end
  
  puts "Cocktails: " 
  p Cocktail.all
  p dynamic_fields
end

ActiveRecord::Base.logger = Logger.new(STDOUT)
db = ActiveRecordDB.new
p db.search('Martini')
