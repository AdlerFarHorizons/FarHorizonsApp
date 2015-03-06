require 'test_helper'

class GroundTracksControllerTest < ActionController::TestCase
  setup do
    @ground_track = ground_tracks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ground_tracks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ground_track" do
    assert_difference('GroundTrack.count') do
      post :create, ground_track: { no_edit: @ground_track.no_edit, source_id: @ground_track.source_id }
    end

    assert_redirected_to ground_track_path(assigns(:ground_track))
  end

  test "should show ground_track" do
    get :show, id: @ground_track
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ground_track
    assert_response :success
  end

  test "should update ground_track" do
    patch :update, id: @ground_track, ground_track: { no_edit: @ground_track.no_edit, source_id: @ground_track.source_id }
    assert_redirected_to ground_track_path(assigns(:ground_track))
  end

  test "should destroy ground_track" do
    assert_difference('GroundTrack.count', -1) do
      delete :destroy, id: @ground_track
    end

    assert_redirected_to ground_tracks_path
  end
end
