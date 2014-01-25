require_relative 'cocktail'
require_relative 'recipe_step'
require_relative 'ingredient'

class ActiveRecordDB
  def search(criteria)
    keywords = criteria.split(' ')
    query = Cocktail.joins(:ingredients)
    keywords.each do |k|
      k = "%#{k.downcase}%"
      query = query.where("lower(ingredients.name) like ?", k)
      query = query.where("lower(cocktails.name) like ?", k)
    end
    return Cocktail.joins(:ingredients).where(query.where_values.join(" OR "))
  end

  def get(name)
    return Cocktail.where(name: name)
  end
  
  def all_ingredients_names()
    return Ingredient.select(:name)
  end
  
  def size
    return Cocktail.count
  end
end