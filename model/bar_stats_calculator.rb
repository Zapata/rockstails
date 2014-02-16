require_relative 'bar_stats'

class BarStatsCalculator
  def compute_stats(cocktails, bar)
    bar_stats = BarStats.new
    
    cocktails.each do |c|
      if bar.can_do?(c)
        bar_stats.add_cocktail(c.rate)
      else
        missing_ingredients = (c.ingredient_names.to_set - bar.ingredient_names)
        if missing_ingredients.size == 1
          bar_stats.add_missing_ingredient(missing_ingredients.first, c.rate)
        end
        missing_ingredients.each { |i| bar_stats.add_ingredient_occurence(i, c.rate) }
      end
    end
    return bar_stats
  end
end