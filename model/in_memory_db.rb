require_relative 'bar_stats_calculator'

module InMemoryDB
  def search(keywords, bar)
    result = @cocktails.select do |c|
      (bar.nil? or bar.can_do?(c)) and c.match(keywords)
    end
    return result.sort { |c1, c2| - (c1.rate <=> c2.rate) }
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
  
  private
  
end