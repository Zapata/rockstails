require 'yaml'
require_relative 'yaml_bar'
require_relative 'yaml_cocktail'
require_relative '../in_memory_db'
require_relative '../ingredient_manager'

class FileDB
  def initialize(db_path, options = {})
    @db_path = db_path
    @compact = options.fetch(:compact, true)
    
    unless options.fetch(:lazy, false)
      load_all_cocktails
      load_all_bars
    end
  end

  include InMemoryDB
  include IngredientManager

  def load_all_cocktails
    if @cocktails.nil?
      puts "Loading cocktail database in memory from YAML, this may take a while..."
      if @compact
        @cocktails = load_cocktails_compact(@db_path + '/cocktails.yml')
      else
        @cocktails = load_cocktails(@db_path + '/cocktails')
      end
    end
    @cocktails
  end

  def load_all_bars
    if @bars.nil?
      @bars = load_bars(@db_path + '/bar')
    end
    @bars
  end
    
  private 
  
  def load_cocktails(cocktail_path)
    beginning_time = Time.now
    cocktails = []
    Dir[cocktail_path + '/*.yml'].each do |f|
      cocktails << YamlCocktail.new(YAML::load_file(f))
    end
    cocktails_end_time = Time.now
    puts "Cocktail Database loaded in #{cocktails_end_time - beginning_time} seconds with #{cocktails.size} cocktails."
    return cocktails
  end

  def load_cocktails_compact(cocktail_file)
    beginning_time = Time.now
    cocktails = []
    YAML::load_file(cocktail_file).each do |cocktail|
      cocktails << YamlCocktail.new(cocktail)
    end
    cocktails_end_time = Time.now
    puts "Cocktail Database loaded in #{cocktails_end_time - beginning_time} seconds with #{cocktails.size} cocktails."
    return cocktails
  end
  
  def load_bars(bar_path)
    bars = []
    Dir[bar_path + '/*.yml'].each do |bar_file|
      beginning_time = Time.now
      bar = YamlBar.new(bar_file)
      end_time = Time.now
      puts "Bar #{bar.name} loaded in #{end_time - beginning_time} seconds with #{bar.ingredients.size} ingredients."
      bars << bar
    end
    return bars
  end
end