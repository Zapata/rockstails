require_relative 'bar_stats_calculator'

module InMemoryDB
  def search(keywords, bar, added_ingredient = nil)
    return @cocktails.select do |c|
      (added_ingredient.nil? or c.ingredient_names.include?(added_ingredient)) and
        (bar.nil? or bar.can_do?(c)) and 
          c.match(keywords)
    end
  end
  
  def get(name)
    return @cocktails.find { |c| c.name == name }
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
  
  def bar_stats(bar_name)
    return BarStatsCalculator.new.compute_stats(@cocktails, bar(bar_name))
  end
end