require 'test_helper'

class PredictedTracksControllerTest < ActionController::TestCase
  setup do
    @predicted_track = predicted_tracks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:predicted_tracks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create predicted_track" do
    assert_difference('PredictedTrack.count') do
      post :create, predicted_track: { file_path: @predicted_track.file_path, source: @predicted_track.source }
    end

    assert_redirected_to predicted_track_path(assigns(:predicted_track))
  end

  test "should show predicted_track" do
    get :show, id: @predicted_track
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @predicted_track
    assert_response :success
  end

  test "should update predicted_track" do
    patch :update, id: @predicted_track, predicted_track: { file_path: @predicted_track.file_path, source: @predicted_track.source }
    assert_redirected_to predicted_track_path(assigns(:predicted_track))
  end

  test "should destroy predicted_track" do
    assert_difference('PredictedTrack.count', -1) do
      delete :destroy, id: @predicted_track
    end

    assert_redirected_to predicted_tracks_path
  end
end
