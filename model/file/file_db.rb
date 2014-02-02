require 'yaml'
require_relative 'bar'
require_relative 'yaml_cocktail'

class FileDB
  def initialize(db_path)
    puts "Loading cocktail database in memory from YAML, this may take a while..."
    load_cocktails(db_path + '/cocktails')
    load_bars(db_path + '/bar')
  end
  
  def search(keywords, bar_name)
    return @cocktails if keywords.nil? or keywords.empty?
    found_cocktails = []
    @cocktails.each do |c|
      ingredients = c.ingredient_names
      found_cocktails << c if keywords.all? do |k|
        re = /#{k}/i
        c.name =~ re || ! ingredients.grep(re).empty?
      end 
    end
    
    bar = bar(bar_name)
    found_cocktails = bar.filter(found_cocktails) unless bar.nil?

    return found_cocktails
  end

  def get(name)
    return @cocktails.find { |c| c[:name] == name }
  end
  
  def all_ingredients_names()
    return @cocktails.each_with_object(Set.new) { |c, s| s.merge(c.ingredient_names) }
  end
  
  def size
    return @cocktails.size
  end
  
  def bar_names
    return @bars.collect { |bar| bar.name }
  end
  
  def bar(bar_name)
    return @bars.find { |bar| bar.name == bar_name }
  end
  
  def add_ingredient_to_bar(bar_name, ingredient_name)
    bar = bar(bar_name)
    bar.add(ingredient_name)
    bar.save
  end
  
  private 
  
  def load_cocktails(cocktail_path)
    beginning_time = Time.now
    @cocktails = []
    Dir[cocktail_path + '/*.yml'].each do |f|
      @cocktails << YamlCocktail.new(YAML::load_file(f))
    end
    cocktails_end_time = Time.now
    puts "Cocktail Database loaded in #{cocktails_end_time - beginning_time} seconds with #{@cocktails.size} cocktails."
  end
  
  def load_bars(bar_path)
    @bars = []
    Dir[bar_path + '/*.yml'].each do |bar_file|
      beginning_time = Time.now
      bar = Bar.new(bar_file)
      end_time = Time.now
      puts "Bar #{bar.name} loaded in #{end_time - beginning_time} seconds with #{bar.ingredients.size} ingredients."
      @bars << bar
    end
  end
end