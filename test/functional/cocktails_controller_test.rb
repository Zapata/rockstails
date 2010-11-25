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
      post :create, :cocktail => @cocktail.attributes
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
end
