ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'yaml'
require 'rails/test_help'
require 'tools/lib/dirty_cocktail'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting

  # no fixtures with MongoMapper
  # fixtures :all

  # Add more helper methods to be used by all tests here...
  def init_cocktails()
    @cocktails = []
    Dir[Rails.root.join("lib/tools/db", "**", "*.yml")].each do |f|
      @cocktails << Cocktail.new.copy_from(YAML::load_file(f))
    end
  end
end

