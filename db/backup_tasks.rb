namespace :db do 
  COMPACT_DATABASE = 'datas/cocktails.yml'
  
  desc 'Import cocktails from datas/cocktails to database (use DATABASE_URL to set the database).'
  task :import_cocktails do
    require_relative '../model/activerecord/cocktail'
    require_relative '../model/activerecord/ingredient'
    require_relative '../model/activerecord/recipe_step'

    Cocktail.delete_all
    
    Dir['datas/cocktails/*.yml'].each do |f|
      created = Cocktail.create! do |db_cocktail|
        db_cocktail.from_yaml(YAML::load_file(f))
      end
      puts "Created cocktail: #{created.name} with id #{created.id}."
    end
  end

  desc 'Import cocktails from datas/cocktails.yml (use DATABASE_URL to set the database).'
  task :import_cocktails_compact do
    require_relative '../model/activerecord/cocktail'
    require_relative '../model/activerecord/ingredient'
    require_relative '../model/activerecord/recipe_step'

    Cocktail.delete_all
    
    YAML::load_file(COMPACT_DATABASE).each do |cocktail|
      created = Cocktail.create! do |db_cocktail|
        db_cocktail.from_yaml(cocktail)
      end
      puts "Created cocktail: #{created.name} with id #{created.id}."
    end
  end
  
  
  desc 'Import bars from datas/bar to database (use DATABASE_URL to set the database).'
  task :import_bars do
    require_relative '../model/activerecord/ingredient'
    require_relative '../model/activerecord/bar'
    
    Bar.delete_all
    
    Dir['datas/bar/*.yml'].each do |f|
      yml_bar = YAML::load_file(f)
      
      Bar.create! do |bar|
        bar.name = File.basename(f, ".yml").capitalize
        puts "Processing #{bar.name}..."
        yml_bar.each do |i|
          ingredients = Ingredient.where("lower(name) like ?", "%#{i.downcase}%")
          bar.ingredients << ingredients
        end
        puts "  added #{bar.ingredients.size} ingredients"
      end
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

    Cocktail.all_as_yaml().each do |cocktail|
      filename = "datas/cocktails/#{sanitize_name(cocktail['name'])}.yml"
      puts "Save '#{cocktail['name']}' into '#{filename}'."
      File.open(filename, 'w') do |file|
        file.write(cocktail.to_yaml())
      end
    end
  end
  
  desc 'Export all cocktails into one YAML file (use DATABASE_URL to set the database).'
  task :export_cocktails_compact do
    require_relative 'activerecord_yaml_serializer'
    require_relative '../model/activerecord/cocktail'
    require_relative '../model/activerecord/recipe_step'
    require_relative '../model/activerecord/ingredient'

    cocktails = Cocktail.all_as_yaml()
    puts "Write #{cocktails.length} cocktails into '#{COMPACT_DATABASE}'"
    File.open(COMPACT_DATABASE, 'w') do |file|
      file.write(cocktails.to_yaml())
    end
  end
  
  desc 'Export bars content into datas/bar in YAML (use DATABASE_URL to set the database).'
  task :export_bars do
    require_relative '../model/activerecord/bar'
    require_relative '../model/activerecord/ingredient'
    
    Bar.all.find_each do |bar|
      filename = "datas/bar/#{sanitize_name(bar.name.downcase)}.yml"
      puts "Save '#{bar.name}' into '#{filename}'."
      File.open(filename, 'w') do |file|
        file.write(bar.ingredient_names.to_yaml)
      end
    end
  end

end