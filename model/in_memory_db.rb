module InMemoryDB
  def search(keywords, bar_name)
    return @cocktails if keywords.nil? or keywords.empty?
    found_cocktails = []
    @cocktails.each do |c|
      ingredients = c.ingredient_names
      found_cocktails << c if keywords.all? do |k|
        re = /#{k}/i
        c.name =~ re || ! ingredients.grep(re).empty?
      end
    end

    bar = bar(bar_name)
    found_cocktails = bar.filter(found_cocktails) unless bar.nil?

    return found_cocktails
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

end