require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require_relative 'model/cocktail_db'
require_relative 'model/bar'

configure do
  enable :logging
  set :haml, :format => :html5
  set :db => CocktailDB.load('db')
  set :bars => Bar.load('datas/bar')
end

before do
  @title = "Rock's Tails : Cocktails that rocks!"
  @db = settings.db
  @bars = settings.bars
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
  
  def find_bar(bar_name)
    return @bars.find { |bar| bar.name == bar_name }
  end
  
  def bar_names
    return ["No bar"] + @bars.collect { |bar| bar.name }
  end
end

get '/' do
  haml :search
end

get '/search' do
  @criteria = params[:criteria]
  @selected_bar = params[:usebar]
  logger.info "Searching cocktails with criteria: #{@criteria}."
  found_cocktails =  @db.search(@criteria);
  bar = find_bar(@selected_bar)
  found_cocktails = bar.filter(found_cocktails) unless bar.nil?
  haml :list, :locals =>  { :cocktails => found_cocktails }
end

get '/view/:name' do
  name = u(params[:name])
  cocktail = @db.get(name)
  redirect to('/') if cocktail.nil?
  haml :view, :locals =>  { :cocktail => cocktail }
end

get '/bar/:name' do
  bar = find_bar(u(params[:name]))
  haml :bar, :locals => { :bar => bar }
end

put '/bar/:name/add/:ingredient' do
  bar = find_bar(u(params[:name]))
  bar.add(params[:ingredient])
  bar.save
  redirect back
end

get '/bar/reload' do
  bar = find_bar(u(params[:name]))
  bar.reload
  redirect back
end

get '/ingredients' do
  haml :ingredients, :locals => { :ingredients => @db.all_ingredients.to_a }
end


