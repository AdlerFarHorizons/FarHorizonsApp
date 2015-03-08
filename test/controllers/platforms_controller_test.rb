require 'test_helper'

class PlatformsControllerTest < ActionController::TestCase
  setup do
    @platform = platforms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:platforms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create platform" do
    assert_difference('Platform.count') do
      post :create, platform: { beacon_ids: @platform.beacon_ids, description: @platform.description, identifier: @platform.identifier, platform_server_id: @platform.platform_server_id }
    end

    assert_redirected_to platform_path(assigns(:platform))
  end

  test "should show platform" do
    get :show, id: @platform
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @platform
    assert_response :success
  end

  test "should update platform" do
    patch :update, id: @platform, platform: { beacon_ids: @platform.beacon_ids, description: @platform.description, identifier: @platform.identifier, platform_server_id: @platform.platform_server_id }
    assert_redirected_to platform_path(assigns(:platform))
  end

  test "should destroy platform" do
    assert_difference('Platform.count', -1) do
      delete :destroy, id: @platform
    end

    assert_redirected_to platforms_path
  end
end
