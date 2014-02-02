require 'readline'
require 'pp'
require 'shellwords'
require_relative '../model/file/file_db'

@db = FileDB.new(File.dirname($0) + '/../datas')
@bar = nil

def search(criteria)
  found_cocktails = @db.search(Shellwords.split(criteria), @bar)
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
