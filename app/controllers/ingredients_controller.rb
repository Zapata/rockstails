class IngredientsController < ApplicationController
  # GET /ingredients
  # GET /ingredients.yaml
  def index
    respond_to do |format|
      format.html {
        @pager = Paginator.new(Ingredient.count, 20) do |offset, per_page|
	        Ingredient.all(:offset => offset, :limit => per_page, :order => 'name asc')
	      end
	      @ingredients = @pager.page(params[:page])
        # index.html.erb
      }
      format.yaml {
        @ingredients = Ingredient.all(:limit => 20)
        render :text => @ingredients.to_yaml, :content_type => 'text/yaml'
      }
    end
  end

  # GET /ingredients/1
  # GET /ingredients/1.yaml
  def show
    @ingredient = Ingredient.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.yaml  { render :text => @ingredient.to_yaml, :content_type => 'text/yaml' }
    end
  end

  # GET /ingredients/new
  # GET /ingredients/new.yaml
  def new
    @ingredient = Ingredient.new

    respond_to do |format|
      format.html # new.html.erb
      format.yaml  { render :text => @ingredient.to_yaml, :content_type => 'text/yaml' }
    end
  end

  # GET /ingredients/1/edit
  def edit
    @ingredient = Ingredient.find(params[:id])
  end

  # POST /ingredients
  # POST /ingredients.yaml
  def create
    @ingredient = Ingredient.new(params[:ingredient])

    respond_to do |format|
      if @ingredient.save
        format.html { redirect_to(@ingredient, :notice => 'Ingredient was successfully created.') }
        format.yaml  { render :text => @ingredient.to_yaml, :content_type => 'text/yaml', :status => :created, :location => @ingredient }
      else
        format.html { render :action => "new" }
        format.yaml  { render :text => @ingredient.errors, :content_type => 'text/yaml', :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ingredients/1
  # PUT /ingredients/1.yaml
  def update
    @ingredient = Ingredient.find(params[:id])

    respond_to do |format|
      if @ingredient.update_attributes(params[:ingredient])
        format.html { redirect_to(@ingredient, :notice => 'Ingredient was successfully updated.') }
        format.yaml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.yaml  { render :text => @ingredient.errors, :content_type => 'text/yaml', :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ingredients/1
  # DELETE /ingredients/1.yaml
  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy

    respond_to do |format|
      format.html { redirect_to(ingredients_url) }
      format.yaml  { head :ok }
    end
  end
end
