require 'pp'
require_relative '../model/file/file_db'
require_relative '../model/file/yaml_bar'

# Stats:
#   cocktails_count
#   ingredient_count
#   cocktails_avg_rate
#   ingredients_not_in_bar:
#     cocktails_count
#     cocktails_avg_rate
#     nb_new_cocktails_in_bar (new_cocktails_count - cocktails_count)
#     new_avg_rate_of_bar (cocktails_avg_rate + new_cocktails_rate / cocktails_count + nb_new_cocktails_in_bar)
#

db = FileDB.new('datas')

beginning_time = Time.now

bar_name = 'Marco'

stats = db.ingredient_stats()

bar = db.bar(bar_name)
stats = stats.delete_if { |ingredient_name, stat| bar.include?(ingredient_name)}
  
puts "Best ingredients to buy by number of cocktail they can do:"
pp stats.sort_by { |ingredient_name, stat| -stat[:count] }.first(20)
puts "Best ingredients to buy by average score they have:"
pp stats.sort_by { |ingredient_name, stat| - (stat[:score] / stat[:count]) }.first(20)

doable_cocktails = db.search(nil, bar_name)
nb_doable_cocktails = doable_cocktails.count
score_doable_cocktails = doable_cocktails.inject(0) { |sum, c| sum + c.rate }

stats.each do |ingredient_name, ingredient_stat|
  bar.add(ingredient_name)
  new_doable_cocktails = db.search(nil, bar_name, ingredient_name)
  ingredient_stat[:bar_count] = new_doable_cocktails.count
  ingredient_stat[:bar_score] = new_doable_cocktails.inject(0) { |sum, c| sum + c.rate }
  bar.remove(ingredient_name)
end

puts "Best ingredients to buy number of new doable cocktails:"
pp stats.sort_by { |ingredient_name, stat| -stat[:bar_count] }.first(20)
puts "Best ingredients to buy score of new doable cocktails:"
pp stats.sort_by { |ingredient_name, stat| stat[:bar_count] == 0 ? 0 : - (stat[:bar_score] / stat[:bar_count]) }.first(20)

end_time = Time.now
puts "Calculated stats in #{end_time - beginning_time} seconds."


  