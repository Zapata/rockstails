require 'forwardable'
require_relative 'in_memory_db'

class InMemoryDecorator
  def initialize(db)
    puts 'Initialize in memory db...'
    beginning_time = Time.now
    @db = db
    @cocktails = db.load_all_cocktails
    @bars = db.load_all_bars
    end_time = Time.now
    puts "DB loaded in #{end_time - beginning_time} seconds with #{@cocktails.size} cocktails and #{@bars.size} bars."
  end
  
  include InMemoryDB

  extend Forwardable
  def_delegators :@db, :add_ingredient_to_bar
end