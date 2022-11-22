require "test/unit"
require_relative '../db/database'
require_relative '../model/activerecord/active_record_db'
require_relative 'db_search_test.rb'


class ActiveRecordDBTest < Test::Unit::TestCase
  include SearchInDBTest

  def self.startup
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    @@db ||= ActiveRecordDB.new
  end
  
  def db
    @@db
  end

end