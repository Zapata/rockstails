require 'pp'
require 'benchmark'
require_relative '../model/file/file_db'
require_relative '../model/file/yaml_bar'
require_relative '../model/bar_stats'

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

def print_top(stats)
  stats.each_with_index do |e, i|
    puts "#{i + 1}. #{e[0]} : #{e[1]}"
  end
  puts
end

def print_tops(bar_stats)
  puts
  puts "Nb of doable cocktails : #{bar_stats.count}"
  puts "Average rate : #{bar_stats.avg_rate}"
  
  puts
  puts "Best ingredients to buy by number of cocktail they can do:"
  print_top bar_stats.ingredients.sort_by { |ingredient_name, stat| -stat.count }.first(20)
  puts "Best ingredients to buy by average score they have:"
  print_top bar_stats.ingredients.sort_by { |ingredient_name, stat| - stat.avg_rate }.first(20)
  
  puts "Best ingredients to buy number of new doable cocktails:"
  print_top bar_stats.ingredients.sort_by { |ingredient_name, stat| -stat.count_increase }.first(20)
  puts "Best ingredients to buy score of new doable cocktails:"
  print_top bar_stats.ingredients.sort_by { |ingredient_name, stat| -stat.avg_rate_increase }.first(20)
end

def stats_with_search(db)
  bar_stats = BarStats.new
  
  bar = db.bar('Marco')
  all_cocktails = db.search(nil, bar)
  bar_stats.count = all_cocktails.count
  bar_stats.rate = all_cocktails.inject(0) { |sum, c| sum + c.rate }
  
  db.gather_ingredient_stats(bar_stats, bar)
    
  bar_stats.ingredients.each do |ingredient_name, ingredient_stat|
    bar.add(ingredient_name)
    new_doable_cocktails = db.search(nil, bar, ingredient_name)
    ingredient_stat.count_increase = new_doable_cocktails.count
    ingredient_stat.rate_increase = new_doable_cocktails.inject(0) { |sum, c| sum + c.rate }
    bar.remove(ingredient_name)
  end
  return bar_stats
end

def my_way(db)
  cocktails = db.cocktails
  bar_stats = BarStats.new
  
  bar = db.bar('Marco')

  cocktails.each do |c|
    if bar.can_do?(c)
      bar_stats.add_cocktail(c.rate)
    else
      missing_ingredients = (c.ingredient_names.to_set - bar.ingredients)
      if missing_ingredients.size == 1
        bar_stats.add_missing_ingredient(missing_ingredients.first, c.rate)
      end
      missing_ingredients.each { |i| bar_stats.add_ingredient_occurence(i, c.rate) }
    end
  end
  return bar_stats
end

db = FileDB.new('datas')

stats = stats_with_search(db)
print_tops(stats)

#Benchmark.bm do |x|
#  x.report("with search :") { stats_with_search(db) }
#  x.report("my way :") { my_way(db) }
#end






  