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
end
