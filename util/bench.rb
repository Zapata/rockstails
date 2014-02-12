require 'benchmark'
require 'ruby-prof'
require_relative '../model/file/file_db'
require_relative '../model/file/yaml_bar'

db = FileDB.new('datas')

bar_name = 'Marco'

#puts "Time to search all cocktails matching a bar: "
#Benchmark.bmbm(10) do |x|
#  x.report("set diff :") { db.search(nil, bar_name) }
#end

db.search(nil, bar_name)
result = RubyProf.profile do
  db.search(nil, bar_name)
end

# Print a flat profile to text
printer = RubyProf::GraphHtmlPrinter.new(result)
printer.print(File.new('profile.html', 'w'))