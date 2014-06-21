#! /usr/bin/env ruby


require_relative '../db/database'
require_relative '../model/activerecord/ingredient'
require_relative '../model/activerecord/cocktail'


def rename_ingredients
  File.new('datas/ingredients_rename.csv').each_line do |line|
    parsed_line = line.split(';')
    puts "Bad line: #{line}" if line.size < 2
    old_name = parsed_line[0].delete('"')
    new_name = parsed_line[1].delete('"')
    unless new_name.blank?
      puts "Rename #{old_name} -> #{new_name}"
      ingredient = Ingredient.find_by(name: old_name)
      ingredient.name = new_name
      ingredient.save
    end
  end
end

def merge(source, destination)
  #update all cocktails with source into destination
  Cocktail.where(recipe_steps: {ingredient_id: source.id}).each do |c|
    puts "#{c.name}: #{c.ingredient_names.join(' ')}"
    step = c.recipe_steps.find { |s| s.ingredient_id == source.id }
    step.ingredient = destination
    step.save
  end
  # delete source from ingredients
  source.delete
end


merge(Ingredient.find_by(id: 1010), Ingredient.find_by(id: 897))