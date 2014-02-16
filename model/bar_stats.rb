class IngredientStat
  attr_reader :count, :rate, :count_increase, :rate_increase
  
  def initialize
    @count = 0
    @rate = 0
    @count_increase = 0
    @rate_increase = 0
  end
  
  def add_occurence(rate)
    @count += 1
    @rate += rate
  end

  def add_missing_occurence(rate)
    @count_increase += 1
    @rate_increase += rate
  end
  
  def avg_rate
    return @count == 0 ? 0 : @rate / @count
  end

  def avg_rate_increase
    return @count_increase == 0 ? 0 : @rate_increase / @count_increase
  end
  
  def to_s
    "count=#{@count}, rate=#{@rate}, count_increase=#{@count_increase}, rate_increase=#{@rate_increase}"
  end
end

class BarStats
  attr_reader :count, :rate, :ingredients
  
  def initialize
    @count = 0
    @rate = 0
    @ingredients = {}
  end
  
  def add_ingredient_occurence(ingredient_name, rate)
    @ingredients[ingredient_name] = IngredientStat.new unless @ingredients.has_key?(ingredient_name)
    @ingredients[ingredient_name].add_occurence(rate)
  end

  def add_missing_ingredient(ingredient_name, rate)
    @ingredients[ingredient_name] = IngredientStat.new unless @ingredients.has_key?(ingredient_name)
    @ingredients[ingredient_name].add_missing_occurence(rate)
  end
  
  def add_cocktail(rate)
    @count += 1
    @rate += rate
  end
  
  def avg_rate
    return @count == 0 ? 0 : @rate / @count
  end
  
  def top_ingredients_by_nb_cocktails(count)
    @ingredients.sort_by { |ingredient_name, stat| -stat.count }.first(count)
  end

  def top_ingredients_by_avg_rate(count)
    @ingredients.sort_by { |ingredient_name, stat| -stat.avg_rate }.first(count)
  end

  def top_ingredients_by_nb_new_doable_cocktails(count)
    @ingredients.sort_by { |ingredient_name, stat| -stat.count_increase }.first(count)
  end

  def top_ingredients_by_rate_new_doable_cocktails(count)
    @ingredients.sort_by { |ingredient_name, stat| -stat.avg_rate_increase }.first(count)
  end
end