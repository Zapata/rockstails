# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
require 'yaml'
require 'tools/lib/dirty_cocktail'

Dir[Rails.root.join("lib/tools/db", "**", "*.yml")].each do |f|
  Cocktail.new.copy_from(YAML::load_file(f))
end
