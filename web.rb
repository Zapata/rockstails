require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require 'shellwords'
require_relative 'model/bar_stats'

ENABLE_DB_AUTODETECT = false

configure do
  enable :logging
  set :haml, :format => :html5
  unless !ENABLE_DB_AUTODETECT or ENV['DATABASE_URL'].nil? or ENV['DATABASE_URL'].strip.empty? then
    puts "Use SQL database due to ENV '#{ENV['DATABASE_URL']}'"
    require 'sinatra/activerecord'
    require_relative 'model/hybrid_db'
    set :database, ENV['DATABASE_URL']
    set :db => HybridDB.new('datas')
  else
    puts "Use file due to ENV '#{ENV['DATABASE_URL']}'"
    require_relative 'model/file/file_db'
    set :db => FileDB.new('datas')
  end
end

before do
  @title = "Rock's Tails : Cocktails that rocks!"
  @db = settings.db
  @criteria = nil
  @selected_bar = "No bar"
end

helpers do
  def h(text)
    Rack::Utils.escape(text)
  end

  def u(text)
    Rack::Utils.unescape(text)
  end
  
  def bar_names
    return ["No bar"] + @db.bar_names
  end
end

get '/' do
  haml :search
end

get '/search' do
  @criteria = params[:criteria]
  @selected_bar = params[:usebar]
  logger.info "Searching cocktails with criteria: #{@criteria}."
  beginning_time = Time.now
  bar = @db.bar(@selected_bar)
  found_cocktails =  @db.search(Shellwords.split(@criteria), bar);
  end_time = Time.now
  elapsed_time = (end_time - beginning_time) * 1000
  haml :list, locals:  { cocktails: found_cocktails, elapsed_time: elapsed_time.to_i }
end

get '/view/:name' do
  name = u(params[:name])
  cocktail = @db.get(name)
  redirect to('/') if cocktail.nil?
  haml :view, locals: { cocktail: cocktail }
end

get '/bar' do
  all_cocktails = @db.load_all_cocktails()
  bars = @db.bar_names().collect do |bar_name|
    bar = @db.bar(bar_name)
    bar.compute_stats(all_cocktails)
    bar
  end
  haml :bars, locals: { bars: bars }
end

get '/bar/:name' do
  bar = @db.bar(u(params[:name]))
  bar.compute_stats(@db.load_all_cocktails())
  haml :bar, locals: { bar: bar, ingredients: @db.all_ingredients_names.to_a.sort }
end

put '/bar/:name/:ingredient' do
  @db.add_ingredient_to_bar(u(params[:name]), params[:ingredient])
  redirect back unless request.xhr?
end

delete '/bar/:name/:ingredient' do
  @db.remove_ingredient_from_bar(u(params[:name]), params[:ingredient])
  redirect back unless request.xhr?
end

get '/bar/stats' do
  # TODO.
end


get '/ingredients' do
  haml :ingredients, locals: { ingredients: @db.all_ingredients_names.to_a.sort }
end


