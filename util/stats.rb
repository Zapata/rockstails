require 'pp'
require_relative '../model/file/file_db'
require_relative '../model/file/yaml_bar'

db = FileDB.new('datas')

bar_name = 'Marco'

stats = db.ingredient_stats()

bar = db.bar(bar_name)
stats = stats.delete_if { |ingredient_name, stat| bar.include?(ingredient_name)}
  
puts "Best ingredients to buy by number of cocktail they can do:"
pp stats.sort_by { |ingredient_name, stat| -stat[:count] }.first(20)
puts "Best ingredients to buy by average score they have:"
pp stats.sort_by { |ingredient_name, stat| - (stat[:score] / stat[:count]) }.first(20)

# TODO: calculate score improvement.
nb_doable_cocktails = db.search(nil, bar_name).count
stats.each do |ingredient_name, ingredient_stat|
  bar.add(ingredient_name)
  ingredient_stat[:bar_count] = (db.search(nil, bar_name).count - nb_doable_cocktails)
  bar.remove(ingredient_name)
end

puts "Best ingredients to buy number of new doable cocktails:"
pp stats.sort_by { |ingredient_name, stat| -stat[:bar_count] }.first(20)

  