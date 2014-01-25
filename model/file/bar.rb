require 'yaml'

class Bar
  def Bar.load(bar_path)
    bars = []
    Dir[bar_path + '/*.yml'].each do |bar_file|
          beginning_time = Time.now
          bar = Bar.new(bar_file)
          end_time = Time.now
          puts "Bar #{bar.name} loaded in #{end_time - beginning_time} seconds with #{bar.ingredients.size} ingredients."
          bars << bar
        end
    return bars
  end

  attr_reader :ingredients

  def initialize(bar_file)
    @bar_file = bar_file
    @ingredients = []
    @ingredients.concat(YAML::load_file(bar_file)) unless bar_file.nil?
  end
  
  def name
    return File.basename(@bar_file, '.yml').capitalize
  end

  def add(ingredient_name)
    @ingredients << ingredient_name.encode('UTF-8', 'UTF-8', :invalid => :replace)
  end

  def save()
    File.open(@bar_file, 'w') {|f| f.write(@ingredients.to_yaml) }
  end
  
  def reload
    @ingredients = YAML::load_file(@bar_file )
  end
  
  def filter(cocktails)
    cocktails.find_all do |c|
      c.ingredient_names.all? do |i|
        @ingredients.one? do |k|
          i =~ /\b#{k.encode('UTF-8', 'UTF-8', :invalid => :replace)}\b/i
        end
      end
    end
  end
end