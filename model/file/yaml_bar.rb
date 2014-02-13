require 'yaml'
require 'set'

class YamlBar
  attr_reader :ingredients
  alias :ingredient_names :ingredients

  def initialize(bar_file)
    @bar_file = bar_file
    @ingredients = Set.new
    @ingredients.merge(YAML::load_file(bar_file)) unless bar_file.nil?
  end
  
  def name
    return File.basename(@bar_file, '.yml').capitalize
  end

  def add(ingredient_name)
    @ingredients << ingredient_name.encode('UTF-8', 'UTF-8', :invalid => :replace)
  end

  def remove(ingredient_name)
    @ingredients.delete(ingredient_name)
  end

  def save!()
    File.open(@bar_file, 'w') {|f| f.write(@ingredients.to_yaml) }
  end
  
  def reload
    @ingredients = YAML::load_file(@bar_file).to_set
  end
  
  def include?(ingredient)
    @ingredients.include?(ingredient)
  end
  
  def can_do?(cocktail)
    cocktail.ingredient_names.all? { |i| @ingredients.include?(i)  }
  end
end