require_relative '../model/file/file_db'


def remove_html(s)
  return if s.nil?
  s.gsub!(/<\/?.*?>/, '')
  s.gsub!("\r", ' ')
  s.gsub!("\n", ' ')
  s.squeeze!(" ")
  s.strip!
end


cocktails = YAML::load_file('../datas/cocktails.yml')

cocktails.each do |c|
  remove_html(c['comment'])
  remove_html(c['method'])
  remove_html(c['garnish'])
  remove_html(c['aka'])
  remove_html(c['variant'])
  remove_html(c['origin'])
end

File.open('test.yml', 'w') do |file|
  file.write(cocktails.to_yaml())
end
