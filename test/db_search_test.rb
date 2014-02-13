module SearchInDBTest
  def test_one_criteria
    omit_if(db.size == 0, "Emtpy database")
    cocktails = db.search(['Martini'], nil)
      
    assert(cocktails.detect {|c| c.name == 'Milano' }, 'Should find cocktail with Martini as ingredient')
    assert(cocktails.detect {|c| c.name == 'Cucumber Martini' }, 'Should find cocktail with Martini as name')
    assert(cocktails.size > 50, "Should find many (> 50) cocktails with Martini, found = #{cocktails.size}.")
    assert(cocktails.size < db.size, 'But not too much')
  end

  def test_case_sensitive
    omit_if(db.size == 0, "Emtpy database")
    cocktails_correctcase = db.search(['Martini'], nil)
    cocktails_nocase = db.search(['martini'], nil)
    
    assert_equal(cocktails_correctcase.size, cocktails_nocase.size, 'Search should not be case sensitive')
  end

  def test_multiple_criterias
    omit_if(db.size == 0, "Emtpy database")
    cocktails_rum = db.search(['rum'], nil)
    cocktails_rum_vodka = db.search(['rum', 'vodka'], nil)
      
    assert(cocktails_rum_vodka.detect {|c| c.name == 'Long Island Iced Tea' }, 'Should find cocktail with Long Island Iced Tea as name')
    assert(cocktails_rum_vodka.size < cocktails_rum.size, 'Multiple criteria may only reduce number of results')
  end
  
  def test_bar_filter
    omit_if(db.size == 0, "Emtpy database")
    
    bar = db.bar('Marco')
    cocktails_filtered_for_bar = db.search(nil, bar)
    assert(cocktails_filtered_for_bar.size > 0, 'Should have found something')
    assert(cocktails_filtered_for_bar.size < db.size, 'Should have filtered something')
  end
end