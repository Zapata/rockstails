require "test/unit"
require_relative '../db/database'
require_relative '../model/activerecord/cocktail'
require_relative '../model/activerecord/ingredient'
require_relative '../model/activerecord/recipe_step'
require_relative '../model/activerecord/active_record_db'


class ActiveRecordDBTest < Test::Unit::TestCase
  def setup
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    @db = ActiveRecordDB.new
  end
  
  def test_one_criteria
    cocktails = @db.search('Martini')
    assert(cocktails.detect {|c| c.name == 'Milano' }, 'Should find cocktail with Martini as ingredient')
    assert(cocktails.detect {|c| c.name == 'Cucumber Martini' }, 'Should find cocktail with Martini as name')
    assert(cocktails.size > 50, "Should find many (> 50) cocktails with Martini, found = #{cocktails.size}.")
    assert(cocktails.size < @db.size, 'But not too much')
  end

  def test_case_sensitive
    cocktails_correctcase = @db.search('Martini')
    cocktails_nocase = @db.search('martini')
    
    assert_equal(cocktails_correctcase.size, cocktails_nocase.size, 'Search should not be case sensitive')
  end
  
  

  def test_multiple_criterias
    cocktails = @db.search('rum vodka')
    assert(cocktails.detect {|c| c.name == 'Long Island Iced Tea' }, 'Should find cocktail with Martini as name')
    assert(cocktails.size > 20, "Should find many (> 20) cocktails zith rum and vodka, found = #{cocktails.size}.")
    assert(cocktails.size < @db.size, 'But not too much')
    
  end
end