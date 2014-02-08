require_relative 'file/file_db'
require_relative 'activerecord/active_record_db'

require 'forwardable'


class HybridDB
  def initialize(db_path)
    @file_db = FileDB.new(db_path, lazy: true)
    @sql_db = ActiveRecordDB.new
    @cocktails = @file_db.load_all_cocktails
    @bars = @sql_db.load_all_bars
  end
  
  include InMemoryDB
  
  extend Forwardable
  def_delegators :@sql_db, :add_ingredient_to_bar

end