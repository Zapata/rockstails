require 'pp'
require 'benchmark'

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
  print_top bar_stats.top_ingredients_by_nb_cocktails(20)
  puts "Best ingredients to buy by average score they have:"
  print_top bar_stats.top_ingredients_by_avg_rate(20)
  
  puts "Best ingredients to buy number of new doable cocktails:"
  print_top bar_stats.top_ingredients_by_nb_new_doable_cocktails(20)
  puts "Best ingredients to buy score of new doable cocktails:"
  print_top bar_stats.top_ingredients_by_rate_new_doable_cocktails(20)
end

require_relative '../model/file/file_db'
db = FileDB.new('datas')

#require_relative '../db/database'
#require_relative '../model/activerecord/active_record_db'
#db = ActiveRecordDB.new

print_tops(db.bar('Marco').stats(db.load_all_cocktails()))






  