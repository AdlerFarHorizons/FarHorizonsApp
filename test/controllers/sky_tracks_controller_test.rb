require 'test_helper'

class SkyTracksControllerTest < ActionController::TestCase
  setup do
    @sky_track = sky_tracks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sky_tracks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sky_track" do
    assert_difference('SkyTrack.count') do
      post :create, sky_track: { no_edit: @sky_track.no_edit, source_id: @sky_track.source_id }
    end

    assert_redirected_to sky_track_path(assigns(:sky_track))
  end

  test "should show sky_track" do
    get :show, id: @sky_track
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sky_track
    assert_response :success
  end

  test "should update sky_track" do
    patch :update, id: @sky_track, sky_track: { no_edit: @sky_track.no_edit, source_id: @sky_track.source_id }
    assert_redirected_to sky_track_path(assigns(:sky_track))
  end

  test "should destroy sky_track" do
    assert_difference('SkyTrack.count', -1) do
      delete :destroy, id: @sky_track
    end

    assert_redirected_to sky_tracks_path
  end
end
