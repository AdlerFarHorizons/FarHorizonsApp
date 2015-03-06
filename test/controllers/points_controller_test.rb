require 'test_helper'

class PointsControllerTest < ActionController::TestCase
  setup do
    @point = points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create point" do
    assert_difference('Point.count') do
      post :create, point: { host_id: @point.host_id, no_edit: @point.no_edit, source_id: @point.source_id, time: @point.time, vg: @point.vg, vx: @point.vx, vy: @point.vy, vz: @point.vz, x: @point.x, y: @point.y, z: @point.z }
    end

    assert_redirected_to point_path(assigns(:point))
  end

  test "should show point" do
    get :show, id: @point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @point
    assert_response :success
  end

  test "should update point" do
    patch :update, id: @point, point: { host_id: @point.host_id, no_edit: @point.no_edit, source_id: @point.source_id, time: @point.time, vg: @point.vg, vx: @point.vx, vy: @point.vy, vz: @point.vz, x: @point.x, y: @point.y, z: @point.z }
    assert_redirected_to point_path(assigns(:point))
  end

  test "should destroy point" do
    assert_difference('Point.count', -1) do
      delete :destroy, id: @point
    end

    assert_redirected_to points_path
  end
end
