require 'test_helper'
require 'yaml'
require 'tools/lib/dirty_cocktail'

class AbstractControllerTest < ActionController::TestCase
  setup do
    # Dir[Rails.root.join("lib/tools/db", "**", "*.yml")].each do |f|
    #   Cocktail.new.copy_from(YAML::load_file(f)).save
    # end
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("cocktail:french75")
    @cocktail = Cocktail.first
    @ingredient = Ingredient.first
  end
end

