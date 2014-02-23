require 'shellwords'
require_relative 'file/yaml_bar'

class Criteria
  attr_reader :ingredients_to_include, :ingredients_to_exclude, :keywords
  
  def initialize(string)
    @ingredients_to_include = []
    @ingredients_to_exclude = []
    @keywords = []
    keywords = Shellwords.split(string)
    keywords.each do |k|
      if k[0] == "+"
        k.delete!("+")
        @ingredients_to_include << k
        @keywords << k
      elsif k[0] == "-"
        k.delete!("-")
        @ingredients_to_exclude << k
        # Do not add this word to the search.
      else
        @keywords << k
      end
    end
  end
  
  def has_bar_manipulations?
    return !@ingredients_to_include.empty? || !@ingredients_to_exclude.empty?
  end
  
  def patch_bar(bar, ingredients)
    patched_bar = YamlBar.new(nil)
    (bar.nil? ? ingredients : bar.ingredient_names).each { |i| patched_bar.add(i) }
    patch(patched_bar, @ingredients_to_include, ingredients, :add)
    patch(patched_bar, @ingredients_to_exclude, ingredients, :remove)
    return patched_bar
  end
  
  private
  
  def patch(bar, ingredients, db_ingredients, method_to_apply)
    ingredients.each do |ingredient_to_search|
      re = /#{ingredient_to_search}/i
      db_ingredients.each do |i|
        bar.send(method_to_apply, i) if i =~ re 
      end
    end
  end
end