require 'test_helper'

class RecommandsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recommands)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recommand" do
    assert_difference('Recommand.count') do
      post :create, :recommand => { }
    end

    assert_redirected_to recommand_path(assigns(:recommand))
  end

  test "should show recommand" do
    get :show, :id => recommands(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => recommands(:one).to_param
    assert_response :success
  end

  test "should update recommand" do
    put :update, :id => recommands(:one).to_param, :recommand => { }
    assert_redirected_to recommand_path(assigns(:recommand))
  end

  test "should destroy recommand" do
    assert_difference('Recommand.count', -1) do
      delete :destroy, :id => recommands(:one).to_param
    end

    assert_redirected_to recommands_path
  end
end
