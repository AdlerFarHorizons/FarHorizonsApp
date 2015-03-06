require 'test_helper'

class LocationDevicesControllerTest < ActionController::TestCase
  setup do
    @location_device = location_devices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:location_devices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create location_device" do
    assert_difference('LocationDevice.count') do
      post :create, location_device: { driver: @location_device.driver, make: @location_device.make, model: @location_device.model, persistent: @location_device.persistent, port: @location_device.port, serial_no: @location_device.serial_no }
    end

    assert_redirected_to location_device_path(assigns(:location_device))
  end

  test "should show location_device" do
    get :show, id: @location_device
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @location_device
    assert_response :success
  end

  test "should update location_device" do
    patch :update, id: @location_device, location_device: { driver: @location_device.driver, make: @location_device.make, model: @location_device.model, persistent: @location_device.persistent, port: @location_device.port, serial_no: @location_device.serial_no }
    assert_redirected_to location_device_path(assigns(:location_device))
  end

  test "should destroy location_device" do
    assert_difference('LocationDevice.count', -1) do
      delete :destroy, id: @location_device
    end

    assert_redirected_to location_devices_path
  end
end
