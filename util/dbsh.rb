require 'readline'
require 'pp'
require_relative '../model/dirty_cocktail'
require_relative '../model/cocktail_db'

@db = CocktailDB.load('../db')

def search(criteria)
  found_cocktails = @db.search(criteria)
  found_cocktails.each do |c|
     puts "#{c.name} (" + c.ingredient_names.join(', ') + ")"
  end
end

def view(name)
  pp @db.get(name)
end

loop do
  input = Readline::readline('dbsh> ')
  break if input =~ /exit/
  begin
    eval(input)
  rescue Exception => err
    $stderr << "#{err.class}: #{err.message}#{$/}"
  end  
end
