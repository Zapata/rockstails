require "test/unit"
require_relative '../model/file/file_db'
require_relative '../model/in_memory_decorator'
require_relative 'db_search_test.rb'


class FileInMemoryDBTest < Test::Unit::TestCase
  include SearchInDBTest

  def self.startup
    @@db = InMemoryDecorator.new(FileDB.new('datas'))
  end
  
  def db
    @@db
  end
end