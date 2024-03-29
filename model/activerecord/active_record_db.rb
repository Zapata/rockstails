require 'active_record'

require_relative 'cocktail'
require_relative 'recipe_step'
require_relative 'ingredient'
require_relative 'bar'
require_relative '../ingredient_manager'

class ActiveRecordDB
  def search(keywords, bar)
    query = build_criteria_query(keywords)
    query = append_bar_filter(query, bar)
    return query.load
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
    return Bar.unscope(:includes).pluck(:name)
  end
  
  def bar(bar_name)
    return nil if bar_name.nil?
    return Bar.find_by(name: bar_name)
  end
  
  def load_all_cocktails
    return Cocktail.all.to_a
  end

  def load_all_bars
    return Bar.all.to_a
  end
  
  def bar_stats(bar_name)
    return BarStatsCalculator.new.compute_stats(load_all_cocktails, bar(bar_name))
  end

  include IngredientManager
  
  private
  
  def build_criteria_query(keywords)
    return Cocktail.all if keywords.nil? or keywords.empty?
    query_ingredients = Cocktail.all
    query_name = Cocktail.all
    keywords.each do |k|
      k = "%#{k.downcase}%"
      query_ingredients = query_ingredients.where("exists (select 1 from ingredients i inner join recipe_steps rs ON rs.ingredient_id = i.id and rs.cocktail_id = cocktails.id where lower(i.name) like ?)", k)
      query_name = query_name.where("lower(cocktails.name) like ?", k)
    end
    return query_name.or(query_ingredients).order(rate: :desc)
  end
  
  def append_bar_filter(query, bar)
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