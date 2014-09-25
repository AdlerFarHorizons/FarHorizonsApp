class TrackExampleController < ApplicationController
  def index
    @sky_tracks = SkyTrack.all
    @ground_tracks = GroundTrack.all
  end
end
