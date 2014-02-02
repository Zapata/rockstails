require 'rake'

namespace :db do 
  desc 'Import cocktails from datas/cocktails to database (use DATABASE_URL to set the database).'
  task :import_cocktails do
    require_relative '../model/activerecord/cocktail'
    require_relative '../model/activerecord/ingredient'
    require_relative '../model/activerecord/recipe_step'

    Cocktail.delete_all
    
    Dir['datas/cocktails/*.yml'].each do |f|
      created = Cocktail.create! do |db_cocktail|
        yaml_hash = YAML::load_file(f)
        recipe_steps = yaml_hash.delete('recipe_steps')
        db_cocktail.attributes = yaml_hash
        recipe_steps.each_with_index do |step, index|
          ingredient = Ingredient.where(name: step['ingredient_name']).first_or_create
          db_cocktail.recipe_steps << RecipeStep.new(position: index, amount: step['amount'], doze: step['doze'], ingredient: ingredient)
        end
      end
      puts "Created cocktail: #{created.name} with id #{created.id}."
    end
  end
  
  
  desc 'Import bars from datas/bar to database (use DATABASE_URL to set the database).'
  task :import_bars do
    require_relative '../model/activerecord/ingredient'
    require_relative '../model/activerecord/bar'
    
    ::Bar.delete_all
    
    Dir['datas/bar/*.yml'].each do |f|
      yml_bar = YAML::load_file(f)
      bar = ::Bar.new
      bar.name = File.basename(f, ".yml").capitalize
      puts "Processing #{bar.name}..."
      yml_bar.each do |i|
        ingredients = ::Ingredient.where("lower(name) like ?", "%#{i.downcase}%")
        bar.ingredients << ingredients
      end
      puts "  added #{bar.ingredients.size} ingredients"
      bar.save!
    end
  end
  
  def sanitize_name(name)
     name = name.gsub(/ /, '_')
     return name.gsub(/[^0-9A-Za-z_\-]/, '')
  end
  
  desc 'Export cocktails into datas/cocktails in YAML (use DATABASE_URL to set the database).'
  task :export_cocktails do
    require_relative 'activerecord_yaml_serializer'
    require_relative '../model/activerecord/cocktail'
    require_relative '../model/activerecord/recipe_step'
    require_relative '../model/activerecord/ingredient'

    Cocktail.all.includes(recipe_steps: [:ingredient]).find_each do |db_cocktail|
      filename = "datas/cocktails/#{sanitize_name(db_cocktail.name)}.yml"
      puts "Save '#{db_cocktail.name}' into '#{filename}'."
      File.open(filename, 'w') do |file|
        yaml = db_cocktail.as_yaml(except: [:id, :created_at, :updated_at],
        include: {
          recipe_steps: {
            except: [:id, :cocktail_id, :ingredient_id, :position],
            methods: [:ingredient_name]
          }
        })
        file.write(yaml)
      end
    end
  end
  
  desc 'Export bars content into datas/bar in YAML (use DATABASE_URL to set the database).'
  task :export_bars do
    require_relative '../model/activerecord/bar'
    require_relative '../model/activerecord/ingredient'
    
    Bar.all.includes(:ingredients).find_each do |bar|
      filename = "datas/bar/#{sanitize_name(bar.name.downcase)}.yml"
      puts "Save '#{bar.name}' into '#{filename}'."
      File.open(filename, 'w') do |file|
        file.write(bar.ingredient_names.to_yaml)
      end
    end
  end

end