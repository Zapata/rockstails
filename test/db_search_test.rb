require_relative '../model/criteria'

module SearchInDBTest
  def test_one_criteria
    omit_if(db.size == 0, "Emtpy database")
    cocktails = db.search(['Mint'], nil)
      
    assert(cocktails.detect {|c| c.name == 'Havanatheone' }, 'Should find cocktail with Mint as ingredient')
    assert(cocktails.detect {|c| c.name == 'Mint Julep' }, 'Should find cocktail with Mint as name')
    assert(cocktails.size > 50, "Should find many (> 50) cocktails with Martini, found = #{cocktails.size}.")
    assert(cocktails.size < db.size, 'But not too much')
  end

  def test_case_sensitive
    omit_if(db.size == 0, "Emtpy database")
    cocktails_correctcase = db.search(['Mint'], nil)
    cocktails_nocase = db.search(['mint'], nil)
    
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
  
  def test_add_ingredient_for_search
    omit_if(db.size == 0, "Emtpy database")
    omit_if(db.is_a?(ActiveRecordDB), "Not implemented") if defined? ActiveRecordDB
    
    bar = db.bar('Binou')
    assert(!bar.include?('Kiwi fruit'), 'Bar should not have kiwi!')
    
    cocktails_with_kiwi = db.search(['kiwi'], bar)
    assert(cocktails_with_kiwi.size == 0, 'Should have found nothing')

    criterias = Criteria.new('+kiwi')
    if criterias.has_bar_manipulations?
      bar = criterias.patch_bar(bar, db.all_ingredients_names) 
    end
    
    cocktails_with_kiwi = db.search(criterias.keywords, bar)
    assert(cocktails_with_kiwi.size > 0, 'Should have found something')
    
    assert(!db.bar('Binou').include?('Kiwi fruit'), 'Bar should not have kiwi!')
  end

  def test_exclude_ingredient_for_search_on_bar
    bar = db.bar('Marco')
    assert(bar.include?('Vodka'), 'Bar should have Vodka!')

    check_exclude_ingredient_for_search(bar)
    
    assert(db.bar('Marco').include?('Vodka'), 'Bar should still have vodka!')
  end
  
  def test_exclude_ingredient_for_search_on_no_bar
    check_exclude_ingredient_for_search(nil)
  end

  private 
  
  def check_exclude_ingredient_for_search(bar)
    omit_if(db.size == 0, "Emtpy database")
    omit_if(db.is_a?(ActiveRecordDB), "Not implemented") if defined? ActiveRecordDB
    
    cocktails_with_rum = db.search(['rum'], bar)
    assert(cocktails_with_rum.size > 0, 'Should have found something')

    criterias = Criteria.new('rum -vodka')
    if criterias.has_bar_manipulations?
      bar = criterias.patch_bar(bar, db.all_ingredients_names) 
    end
    
    cocktails_with_rum_but_no_vodka = db.search(criterias.keywords, bar)
    assert(cocktails_with_rum.size > cocktails_with_rum_but_no_vodka.size, 'Should have found less cocktails when excluding vodka')
    assert(cocktails_with_rum_but_no_vodka.size > 0, 'But should have found something')
  end
end