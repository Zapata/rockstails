#! /usr/bin/env ruby

require 'set'
require 'yaml'
require 'amatch'
require 'lib/dirty_cocktail'

def write_to_file(object, filename)
  File.open(filename, 'w') {|f| f.write(object.to_yaml) }
end

class CocktailCleaner
  
  def initialize(cocktail_file)
    @file = cocktail_file
    @cocktail = YAML::load_file(cocktail_file)
    @modifications = []
  end
        
  def clean!(ingredients, dozes)
    unless (@cocktail.ingredients.all? {|i| i.size == 3})
      clean_ingredient_size()
    end
    ingredients = @cocktail.ingredient_names
    unless (ingredients.size == ingredients.uniq.size)
      clean_ingredient_duplicate()
    end
    checks = [[DirtyCocktail::IDX_INGREDIENT, ingredients], 
                    [DirtyCocktail::IDX_DOZE, dozes]]
    @cocktail.ingredients.each_with_index do |ingredient, i|
      checks.each do |index, all_names|
        if !all_names.include?(ingredient[index])
          ingredient = clean_name(ingredient, index, all_names)
        end
      end
      @cocktail.ingredients[i] = ingredient
    end
    save
  end
   
  private
  
  def clean_ingredient_size()
    ings = @cocktail.ingredients.flatten
    cleaned_ingredients = []
    while !ings.empty?
      amount = ings.shift
      if ['Top up with',   'Float', 'Float lightly whipped', 'unit'].include?(amount)
        doze = amount
        amount = "1"
      else
        doze = ings.shift
      end
      ing = ings.shift
      cleaned_ingredients << [amount, doze, ing]
    end
    @cocktail.ingredients = cleaned_ingredients
    @modifications << 'clean size'
  end
  
  def clean_ingredient_duplicate()
    uniq_ingredients = Set.new
    @cocktails.ingredients.delete_if do |e|
      ing = e[DirtyCocktail::IDX_INGREDIENT]
      to_delete = uniq_ingredients.include?(ing)
      uniq_ingredients << ing
      return to_delete
    end    
    @modifications << 'clean duplicates'    
  end
  
  def clean_name(ingredient, index, all_names)
    real_name = ingredient[index]
    return ingredient if real_name.nil?

    if (real_name =~ /.*<.+>(.+)<\/.+>/)
      real_name = $1
    end
    
    unless all_names.include?(real_name)
      real_name = find_neerest(real_name, all_names)
    end
    
    if all_names.include?(real_name)
      ingredient[index] = real_name
      @modifications << "clean name (#{real_name})"
    else
      error('Bad name', real_name)
    end
    return ingredient
  end
  
  PIVOT = 0.825
  def find_neerest(one, all)
    max_similarity = nil
    neerest = nil
    m = Amatch::JaroWinkler.new(one)
    all.each do |a|
      similarity = m.match(a)
      if max_similarity.nil? || max_similarity < similarity
        max_similarity = similarity
        neerest = a
      end
    end
    if (max_similarity < PIVOT)
      puts "#{one} => #{neerest} (#{max_similarity})"
    end
    return max_similarity > PIVOT ? neerest : one 
  end
  
  def error(error_string, object)
    puts @cocktail.name + ' : ' + error_string + ':'
    puts object.to_yaml
  end
  
  def save
    unless @modifications.empty?
      puts "Modify #{@cocktail.name}: #{@modifications.join(' ')}"  
      #write_to_file(@cocktail, @file)
    end 
  end

end


def clean_all()
  ingredients = YAML::load_file('../datas/ingredients.yml')
  dozes = YAML::load_file('../datas/dozes.yml')
  Dir['../db/*.yml'].each do |f|
    cc = CocktailCleaner.new(f)
    cc.clean!(ingredients, dozes)
  end
end

def get_unique_from_ingredients(index)
  unique = Set.new
  Dir['../db/*.yml'].each do |f|
    c = YAML::load_file(f)
    c.ingredients.each do |i|
      unique << i[index]
    end
  end
  return unique
end

def get_unique(symbol)
  unique = Set.new
  Dir['../db/*.yml'].each do |f|
    c = YAML::load_file(f)
    unique << c.send(symbol)
  end
  return unique
end

clean_all

#write_to_file(get_unique(:glass), 'glass.yml')

#write_to_file(get_unique_from_ingredients(DirtyCocktail::IDX_DOZE), 'doze.yml')
#write_to_file(get_unique_from_ingredients(DirtyCocktail::IDX_AMOUNT), 'size.yml')
