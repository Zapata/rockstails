require 'functional/abstract_controller_test'

class CocktailsControllerTest < AbstractControllerTest

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cocktails)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cocktail" do
    assert_difference('Cocktail.count') do
      post :create, :cocktail => { :name => "Toto" }
    end

    assert_redirected_to cocktail_path(assigns(:cocktail))
  end

  test "should show cocktail" do
    get :show, :id => @cocktail.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cocktail.to_param
    assert_response :success
  end

  test "should update cocktail" do
    put :update, :id => @cocktail.to_param, :cocktail => @cocktail.attributes
    assert_redirected_to cocktail_path(assigns(:cocktail))
  end

  test "should destroy cocktail" do
    assert_difference('Cocktail.count', -1) do
      delete :destroy, :id => @cocktail.to_param
    end

    assert_redirected_to cocktails_path
  end

  test "should propose ingredients for cocktail" do
    get :select_ingredient, :id => @cocktail.to_param
    assert_response :success
  end

  test "should add ingredient to cocktail" do
    put :add_ingredient, :id => @cocktail.to_param, :ingredient => @ingredient.attributes, :composition => { :amount => "1", :doze => "oz" }
    assert_redirected_to cocktail_path(assigns(:cocktail))
  end
end
