module InMemoryDB
  def search(keywords, bar_name)
    bar = bar(bar_name)

    return @cocktails.select do |c|
        c.match(keywords) and (bar.nil? or bar.can_do(c))
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
  
  def ingredient_stats
    stats = {}
    @cocktails.each do |c|
      c.ingredient_names.each do |i|
        stats[i] = { count: 0, score: 0 } unless stats.has_key?(i)
        stats[i][:count] += 1
        stats[i][:score] += c.rate
      end
    end
    return stats
  end
end