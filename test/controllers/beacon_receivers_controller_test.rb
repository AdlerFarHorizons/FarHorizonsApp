require 'test_helper'

class BeaconReceiversControllerTest < ActionController::TestCase
  setup do
    @beacon_receiver = beacon_receivers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:beacon_receivers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create beacon_receiver" do
    assert_difference('BeaconReceiver.count') do
      post :create, beacon_receiver: { driver: @beacon_receiver.driver, make: @beacon_receiver.make, model: @beacon_receiver.model, persistent: @beacon_receiver.persistent, port: @beacon_receiver.port, serial_no: @beacon_receiver.serial_no }
    end

    assert_redirected_to beacon_receiver_path(assigns(:beacon_receiver))
  end

  test "should show beacon_receiver" do
    get :show, id: @beacon_receiver
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @beacon_receiver
    assert_response :success
  end

  test "should update beacon_receiver" do
    patch :update, id: @beacon_receiver, beacon_receiver: { driver: @beacon_receiver.driver, make: @beacon_receiver.make, model: @beacon_receiver.model, persistent: @beacon_receiver.persistent, port: @beacon_receiver.port, serial_no: @beacon_receiver.serial_no }
    assert_redirected_to beacon_receiver_path(assigns(:beacon_receiver))
  end

  test "should destroy beacon_receiver" do
    assert_difference('BeaconReceiver.count', -1) do
      delete :destroy, id: @beacon_receiver
    end

    assert_redirected_to beacon_receivers_path
  end
end
