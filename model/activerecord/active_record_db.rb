require_relative 'cocktail'
require_relative 'recipe_step'
require_relative 'ingredient'
require_relative 'bar'

ActiveRecord::Base.disable_implicit_join_references = true

class ActiveRecordDB
  def search(criteria, bar_name)
    query = build_criteria_query(criteria)
    query = append_bar_filter(query, bar_name)
    return query.includes(:ingredients).load
  end

  def get(name)
    return Cocktail.find_by(name: name)
  end
  
  def all_ingredients_names()
    return Ingredient.select(:name)
  end
  
  def size
    return Cocktail.count
  end
  
  def bar_names
    return Bar.pluck(:name)
  end
  
  def bar(bar_name)
    return Bar.find_by(name: bar_name)
  end
  
  def add_ingredient_to_bar(bar_name, ingredient_name)
    bar = bar(bar_name)
    bar.ingredients << Ingredient.where(name: ingredient_name)
    bar.save!
  end
  
  private
  
  def build_criteria_query(criteria)
    return Cocktail.all if criteria.nil? or criteria.blank?
    keywords = criteria.split(' ')
    query_ingredients = Cocktail.all
    query_name = Cocktail.all
    keywords.each do |k|
      k = "%#{k.downcase}%"
      query_ingredients = query_ingredients.where("exists (select 1 from ingredients i inner join recipe_steps rs ON rs.ingredient_id = i.id and rs.cocktail_id = cocktails.id where lower(i.name) like ?)", k)
      query_name = query_name.where("lower(cocktails.name) like ?", k)
    end
    criteria_ingredients = query_ingredients.where_values.join(" AND ")
    criteria_name = query_name.where_values.join(" AND ")
    return Cocktail.where("(#{criteria_name}) OR (#{criteria_ingredients})")
  end
  
  def append_bar_filter(query, bar_name)
    bar = bar(bar_name)
    unless bar.nil?
      sql_query = """
      not exists (
        (select i.name from ingredients i inner join recipe_steps step on step.ingredient_id = i.id and step.cocktail_id = cocktails.id) 
        EXCEPT  
        (select i.name from ingredients i inner join bars_ingredients bi on bi.ingredient_id = i.id and bi.bar_id = ?)
      )
      """
      query = query.where(sql_query, bar.id)
    end
    return query
  end
  
end