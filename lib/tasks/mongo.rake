namespace :db do
  namespace :test do
  	task :prepare do
    end
  end

  desc 'Load the seed data from lib/tools/db'
  task :seed => :environment do
    require 'yaml'
    require 'tools/lib/dirty_cocktail'
    require Rails.root + 'app/models/cocktail'
    require Rails.root + 'app/models/ingredient'

    load(Rails.root + 'config/initializers/mongo.rb')
    Dir[Rails.root.join("lib/tools/db", "**", "*.yml")].each do |f|
      Cocktail.new.copy_from(YAML::load_file(f)).save
    end
  end
  
  desc 'Clean database'
  task :drop => :environment do
    load(Rails.root + 'config/initializers/mongo.rb')
    MongoMapper.connection.drop_database(MongoMapper.database.name)
  end
  
  desc 'Reset database to a clean set of datas'
  task :reset => [:drop, :seed]
end
