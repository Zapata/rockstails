require 'sinatra'
require 'sinatra/reloader' if development?
require 'haml'
require_relative 'model/cocktail_db'
require_relative 'model/bar'

configure do
  enable :logging
  set :haml, :format => :html5
  set :db => CocktailDB.load('db')
  set :bar => Bar.load('datas/my_bar_content.yaml')
end

before do
  @title = "Rock's Tails : Cocktails that rocks!"
  @db = settings.db
  @bar = settings.bar
  @criteria = nil
  @usebar = false
end

get '/' do
  haml :search
end

get '/search' do
  @criteria = params[:criteria]
  logger.info "Searching cocktails with criteria: #{@criteria}."
  found_cocktails =  @db.search(@criteria);
  @usebar = params[:usebar] == "yes"
  found_cocktails = bar.filter(found_cocktails) if @usebar
  haml :list, :locals =>  { :cocktails => found_cocktails }
end

get '/view/:name' do
  cocktail = @db.get(params[:name])
  haml :view, :locals =>  { :cocktail => cocktail }
end

get '/bar' do
  haml :bar, :locals => {:bar => @bar}
end

put '/bar/add/:ingredient' do
  @bar.add(params[:ingredient])
  @bar.save
  redirect back
end

get '/bar/reload' do
  @bar.reload
  redirect back
end
