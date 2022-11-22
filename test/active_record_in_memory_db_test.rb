require "test/unit"
require_relative '../db/database'
require_relative '../model/activerecord/active_record_db'
require_relative '../model/in_memory_decorator'
require_relative 'db_search_test.rb'


class ActiveRecordInMemoryDBTest < Test::Unit::TestCase
	include SearchInDBTest

  def self.startup
    #ActiveRecord::Base.logger = Logger.new(STDOUT)
    puts "Startup"
    @@db ||= InMemoryDecorator.new(ActiveRecordDB.new)
  end

  def db
	  @@db
  end

end