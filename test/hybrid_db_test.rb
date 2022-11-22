require "test/unit"
require_relative '../db/database'
require_relative '../model/hybrid_db'
require_relative 'db_search_test.rb'


class HybridDBTest < Test::Unit::TestCase
  class << self
    def startup
      #ActiveRecord::Base.logger = Logger.new(STDOUT)
      @@db ||= HybridDB.new('datas')
    end
  end
  
  def db
    @@db
  end

  include SearchInDBTest
end