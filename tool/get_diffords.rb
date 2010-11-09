#! /usr/bin/env ruby

require 'net/http'
require 'uri'
require 'iconv'
require 'yaml'
require 'lib/dirty_cocktail'

class String
  def to_ascii_iconv
    converter = Iconv.new('ASCII//IGNORE//TRANSLIT', 'UTF-8')
    converter.iconv(self).unpack('U*').select{ |cp| cp < 127 }.pack('U*')
  end
end


  def escape(string)
    string.gsub(/([^ a-zA-Z0-9_-]+)/n, '').tr(' ', '_')
  end

def load_cocktail_from_difford(str, num)
  cocktail = DirtyCocktail.new  
  cocktail.name = str[/name="cocktailName" value="([^"]*)">/, 1]
  return nil if cocktail.name.nil? || cocktail.name.empty?
  cocktail.rate = str[%r|<img src="../images/web/rating_(.*?).gif|, 1].to_f
  cocktail.glass = str[/Glass:.*?<td>(.*?)<\/td>/m, 1]
  cocktail.garnish = str[/Garnish:.*?<td .*?>(.*?)<\/td>/m, 1]
  cocktail.method = str[/<span id="method_".*?>(.*?)<\/span>/m, 1]
  str.scan(/<td colspan="2"><b>(.*?):\s*<\/b> (.*?)<\/td>/m) { |k,v| cocktail.infos[k] = v }
  cocktail.infos['source'] = "www.diffordsguide.com (#{num})"
  ing_table = str[/<table.*?id="ingTable".*?>(.*?)<\/table>/m, 1]
  ingredients = ing_table.scan(/<td.*?>(.*?)<\/td>/m).flatten
  while (not ingredients.empty?) do
    l = ingredients.slice!(0, 3)
    l[0] = l[0]
    l[2].gsub!(/<b>(.*)<\/b>.*/, '\1') unless l[2].nil?
    cocktail.ingredients << l
  end
  return cocktail
end

url = "http://www.diffordsguide.com/site/main/ViewRecipe.jsp?cocktailId="

0.upto(3000) do |i|
  try = 3
  while try > 0
    begin
      res = Net::HTTP.get(URI.parse(url + i.to_s))
      cocktail = load_cocktail_from_difford(res.to_ascii_iconv, i)
      unless cocktail.nil?
        puts "Saving cocktail: #{cocktail.name} (#{i})"
        File.open("db/#{escape(cocktail.name)}.yml", 'w') {|f| f.write(cocktail.to_yaml) }
      end
      try = -1
    rescue
      try -= 1
    end
  end
end

