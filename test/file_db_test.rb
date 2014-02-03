require "test/unit"
require_relative '../model/file/file_db'
require_relative 'db_search_test.rb'


class FileDBTest < Test::Unit::TestCase
  include SearchInDBTest

  def self.startup
    @@db = FileDB.new('datas')
  end
  
  def db
    @@db
  end
end