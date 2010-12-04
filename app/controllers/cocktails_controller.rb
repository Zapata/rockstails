require 'yaml'
require 'tools/lib/dirty_cocktail'

class CocktailsController < ApplicationController
  # GET /cocktails
  # GET /cocktails.yaml
  def index
    respond_to do |format|
      format.html {
        @pager = Paginator.new(Cocktail.count, 20) do |offset, per_page|
	        Cocktail.all(:offset => offset, :limit => per_page, :order => 'name asc')
	      end
	      @cocktails = @pager.page(params[:page])
        # index.html.erb
      }
      format.yaml  {
        @cocktails = Cocktail.all(:limit => 20)
        render :text => @cocktails.to_yaml, :content_type => 'text/yaml'
      }
    end
  end

  # GET /cocktails/1
  # GET /cocktails/1.yaml
  def show
    @cocktail = Cocktail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.yaml  { render :text => @cocktail.to_yaml, :content_type => 'text/yaml' }
    end
  end

  # GET /cocktails/new
  # GET /cocktails/new.yaml
  def new
    @cocktail = Cocktail.new

    respond_to do |format|
      format.html # new.html.erb
      format.yaml  { render :text => @cocktail.to_yaml, :content_type => 'text/yaml' }
    end
  end

  # GET /cocktails/1/edit
  def edit
    @cocktail = Cocktail.find(params[:id])
  end

  # POST /cocktails
  # POST /cocktails.yaml
  def create
    @cocktail = Cocktail.new(params[:cocktail])

    respond_to do |format|
      if @cocktail.save
        format.html { redirect_to(@cocktail, :notice => 'Cocktail was successfully created.') }
        format.yaml  { render :text => @cocktail.to_yaml, :content_type => 'text/yaml', :status => :created, :location => @cocktail }
      else
        format.html { render :action => "new" }
        format.yaml  { render :text => @cocktail.errors, :content_type => 'text/yaml', :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cocktails/1
  # PUT /cocktails/1.yaml
  def update
    @cocktail = Cocktail.find(params[:id])

    respond_to do |format|
      if @cocktail.update_attributes(params[:cocktail])
        format.html { redirect_to(@cocktail, :notice => 'Cocktail was successfully updated.') }
        format.yaml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.yaml  { render :text => @cocktail.errors, :content_type => 'text/yaml', :status => :unprocessable_entity }
      end
    end
  end

  # GET /cocktail/1/select_ingredient
  def select_ingredient
    @cocktail = Cocktail.find(params[:id])
    @ingredients = Ingredient.all
    @composition = Composition.new
  end

  # PUT /cocktail/1/add_ingredient
  # PUT /cocktail/1/add_ingredient.yaml
  def add_ingredient
    @cocktail = Cocktail.find(params[:id])
    @cocktail.compositions << Composition.new(
      :amount => params["composition"]["amount"],
      :doze => params["composition"]["doze"],
      :ingredient => Ingredient.find(params["ingredient"]["id"])
    )

    respond_to do |format|
      if @cocktail.save
        flash[:notice] = 'Cocktail was successfully updated.'
        format.html { redirect_to(@cocktail) }
        format.yaml  { head :ok }
      else
        format.html { render :action => "select_ingredient" }
        format.yaml  { render :yaml => @cocktail.errors, :content_type => 'text/yaml', :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cocktails/1
  # DELETE /cocktails/1.yaml
  def destroy
    @cocktail = Cocktail.find(params[:id])
    @cocktail.destroy

    respond_to do |format|
      format.html { redirect_to(cocktails_url) }
      format.yaml  { head :ok }
    end
  end

  # PUT /cocktails/add_ten_random
  def add_ten_random

    files = Dir[Rails.root.join("lib/tools/db", "**", "*.yml")]

    10.times do
      nb = rand(files.length)
      Cocktail.new.copy_from(YAML::load_file(files[nb])).save
    end   

    respond_to do |format|
      format.html { redirect_to(cocktails_url) }
      format.yaml  { head :ok }
    end
  end
end
