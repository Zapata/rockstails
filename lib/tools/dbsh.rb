#! /usr/bin/env ruby

require 'yaml'
# not needed in ruby 1.9
# require 'facets/array/combination'
require 'pp'
require 'lib/dirty_cocktail'

def write_to_file(object, filename)
  File.open(filename, 'w') {|f| f.write(object.to_yaml) }
end

class CocktailDB
  
  def initialize(db_path)
    @cocktails = []
    Dir[db_path + '/*.yml'].each do |f|
      @cocktails << YAML::load_file(f)
    end
  end

  class Stats
    attr_accessor :rate, :count
    def initialize()
      @rate = 0.0
      @count = 0
    end
    
    def note(max_count)
      (0.7 * @rate / @count / 5) + 0.3 *@count / max_count
      #(0.5 * Math.log(@rate / @count)) + 0.5 *@count / max_count
    end
  end

  def stats_ingredients()
    ing_count = Hash.new()
    @cocktails.each do |c|
      ings = c.get_ingredients.sort
      1.upto(ings.size) do |i|
        ings.combination(i) do |ing_combi|
          unless ing_count.has_key?(ing_combi)
            ing_count[ing_combi] = Stats.new
          end
          ing_count[ing_combi].rate += c.rate
          ing_count[ing_combi].count += 1
        end
      end
    end
    max_count = nil
    ing_count.each_value do |s| 
      max_count = s.count if max_count.nil? || max_count < s.count
    end
    note_sort = ing_count.sort {|a, b| b[1].note(max_count) <=> a[1].note(max_count)}
  end
  
  def best_bar(max_ingredients)
    ingredients = YAML::load_file('datas/ingredients.yml')
    possible_bars = generate_combinations(ingredients)
    
  end
  
  def match(ings)
      return ings.size == 3 && ings.include?("Maker's Mark bourbon") && ings.include?('Angostura aromatic bitters') && ings.include?('Monin Pure Cane sugar syrup (65^0brix, 2:1 sugar/water)')
  end
end

db = CocktailDB.new('db')
write_to_file(db.stats_ingredients(), 'ing_stats.yml')
