require 'test_helper'

class PlatformServersControllerTest < ActionController::TestCase
  setup do
    @platform_server = platform_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:platform_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create platform_server" do
    assert_difference('PlatformServer.count') do
      post :create, platform_server: { hostname: @platform_server.hostname, make: @platform_server.make, model: @platform_server.model, persistent: @platform_server.persistent, serial_no: @platform_server.serial_no, sw_version: @platform_server.sw_version }
    end

    assert_redirected_to platform_server_path(assigns(:platform_server))
  end

  test "should show platform_server" do
    get :show, id: @platform_server
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @platform_server
    assert_response :success
  end

  test "should update platform_server" do
    patch :update, id: @platform_server, platform_server: { hostname: @platform_server.hostname, make: @platform_server.make, model: @platform_server.model, persistent: @platform_server.persistent, serial_no: @platform_server.serial_no, sw_version: @platform_server.sw_version }
    assert_redirected_to platform_server_path(assigns(:platform_server))
  end

  test "should destroy platform_server" do
    assert_difference('PlatformServer.count', -1) do
      delete :destroy, id: @platform_server
    end

    assert_redirected_to platform_servers_path
  end
end
