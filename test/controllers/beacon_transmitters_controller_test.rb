require 'test_helper'

class BeaconTransmittersControllerTest < ActionController::TestCase
  setup do
    @beacon_transmitter = beacon_transmitters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beacon_transmitters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beacon_transmitter" do
    assert_difference('BeaconTransmitter.count') do
      post :create, beacon_transmitter: { call_sign: @beacon_transmitter.call_sign, driver: @beacon_transmitter.driver, make: @beacon_transmitter.make, model: @beacon_transmitter.model, persistent: @beacon_transmitter.persistent, port: @beacon_transmitter.port, serial_no: @beacon_transmitter.serial_no }
    end

    assert_redirected_to beacon_transmitter_path(assigns(:beacon_transmitter))
  end

  test "should show beacon_transmitter" do
    get :show, id: @beacon_transmitter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beacon_transmitter
    assert_response :success
  end

  test "should update beacon_transmitter" do
    patch :update, id: @beacon_transmitter, beacon_transmitter: { call_sign: @beacon_transmitter.call_sign, driver: @beacon_transmitter.driver, make: @beacon_transmitter.make, model: @beacon_transmitter.model, persistent: @beacon_transmitter.persistent, port: @beacon_transmitter.port, serial_no: @beacon_transmitter.serial_no }
    assert_redirected_to beacon_transmitter_path(assigns(:beacon_transmitter))
  end

  test "should destroy beacon_transmitter" do
    assert_difference('BeaconTransmitter.count', -1) do
      delete :destroy, id: @beacon_transmitter
    end

    assert_redirected_to beacon_transmitters_path
  end
end
