require 'test_helper'

class ChaseVehiclesControllerTest < ActionController::TestCase
  setup do
    @chase_vehicle = chase_vehicles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chase_vehicles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create chase_vehicle" do
    assert_difference('ChaseVehicle.count') do
      post :create, chase_vehicle: { chase_server_id: @chase_vehicle.chase_server_id, description: @chase_vehicle.description, identifier: @chase_vehicle.identifier }
    end

    assert_redirected_to chase_vehicle_path(assigns(:chase_vehicle))
  end

  test "should show chase_vehicle" do
    get :show, id: @chase_vehicle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @chase_vehicle
    assert_response :success
  end

  test "should update chase_vehicle" do
    patch :update, id: @chase_vehicle, chase_vehicle: { chase_server_id: @chase_vehicle.chase_server_id, description: @chase_vehicle.description, identifier: @chase_vehicle.identifier }
    assert_redirected_to chase_vehicle_path(assigns(:chase_vehicle))
  end

  test "should destroy chase_vehicle" do
    assert_difference('ChaseVehicle.count', -1) do
      delete :destroy, id: @chase_vehicle
    end

    assert_redirected_to chase_vehicles_path
  end
end
