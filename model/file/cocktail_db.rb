require 'yaml'
require_relative 'dirty_cocktail'

class CocktailDB
  def CocktailDB.load(db_path)
    beginning_time = Time.now
    db = CocktailDB.new(db_path)
    end_time = Time.now
    puts "Database loaded in #{end_time - beginning_time} seconds with #{db.size} cocktails."
    return db
  end
  
  def initialize(db_path)
    @cocktails = []
    Dir[db_path + '/*.yml'].each do |f|
      @cocktails << YAML::load_file(f)
    end
  end
  
  def search(criteria)
    return @cocktails if criteria.empty?
    found_cocktails = []
    keywords = criteria.split(' ')
    @cocktails.each do |c|
      ingredients = c.ingredient_names
      found_cocktails << c if keywords.all? do |k|
        re = /#{k}/i
        c.name =~ re || ! ingredients.grep(re).empty?
      end 
    end
    return found_cocktails
  end

  def get(name)
    return @cocktails.find { |c| c.name == name }
  end
  
  def all_ingredients_names()
    @cocktails.each_with_object(Set.new) { |c, s| s.merge(c.ingredient_names) }
  end
  
  def size
    @cocktails.size
  end
end