require_relative 'file/file_db'
require_relative 'activerecord/active_record_db'

require 'forwardable'


class HybridDB
  def initialize(db_path)
    @file_db = FileDB.new(db_path, lazy: true)
    @sql_db = ActiveRecordDB.new
    @cocktails = @file_db.load_all_cocktails
  end
  
  include InMemoryDB
  
  extend Forwardable
  def_delegators :@sql_db, :bar, :bar_names, :add_ingredient_to_bar, :remove_ingredient_from_bar, :load_all_bars
  def_delegators :@file_db, :load_all_cocktails

end