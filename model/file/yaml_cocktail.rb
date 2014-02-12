require 'hashie'

class YamlCocktail < Hashie::Mash
  def ingredient_names
    @ingredient_names = self[:recipe_steps].collect { |s| s[:ingredient_name] } if @ingredient_names.nil?
    return @ingredient_names
  end
  
  
  
  def match(keywords)
    return true if keywords.nil? or keywords.empty?
    names = ingredient_names
    return keywords.all? do |k|
      re = /#{k}/i
      name =~ re || ! names.grep(re).empty?
    end
  end
end