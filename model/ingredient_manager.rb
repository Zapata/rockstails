module IngredientManager
  def add_ingredient_to_bar(bar_name, ingredient_name)
    bar = bar(bar_name)
    bar.add(ingredient_name)
    bar.save!
    return bar
  end
  
  def remove_ingredient_from_bar(bar_name, ingredient_name)
    bar = bar(bar_name)
    bar.remove(ingredient_name)
    bar.save!
    return bar
  end  
end