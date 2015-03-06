require 'test_helper'

class ChaseServersControllerTest < ActionController::TestCase
  setup do
    @chase_server = chase_servers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chase_servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chase_server" do
    assert_difference('ChaseServer.count') do
      post :create, chase_server: { beacon_receiver_ids: @chase_server.beacon_receiver_ids, beacon_transmitter_id: @chase_server.beacon_transmitter_id, hostname: @chase_server.hostname, location_device_id: @chase_server.location_device_id, make: @chase_server.make, model: @chase_server.model, persistent: @chase_server.persistent, router_id: @chase_server.router_id, serial_no: @chase_server.serial_no, sw_version: @chase_server.sw_version }
    end

    assert_redirected_to chase_server_path(assigns(:chase_server))
  end

  test "should show chase_server" do
    get :show, id: @chase_server
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @chase_server
    assert_response :success
  end

  test "should update chase_server" do
    patch :update, id: @chase_server, chase_server: { beacon_receiver_ids: @chase_server.beacon_receiver_ids, beacon_transmitter_id: @chase_server.beacon_transmitter_id, hostname: @chase_server.hostname, location_device_id: @chase_server.location_device_id, make: @chase_server.make, model: @chase_server.model, persistent: @chase_server.persistent, router_id: @chase_server.router_id, serial_no: @chase_server.serial_no, sw_version: @chase_server.sw_version }
    assert_redirected_to chase_server_path(assigns(:chase_server))
  end

  test "should destroy chase_server" do
    assert_difference('ChaseServer.count', -1) do
      delete :destroy, id: @chase_server
    end

    assert_redirected_to chase_servers_path
  end
end
