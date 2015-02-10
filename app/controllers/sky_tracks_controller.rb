class SkyTracksController < ApplicationController
  before_action :set_sky_track, only: [:show, :edit, :update, :destroy]

  # GET /sky_tracks
  # GET /sky_tracks.json
  def index
    @sky_tracks = SkyTrack.all
  end

  # GET /sky_tracks/1
  # GET /sky_tracks/1.json
  def show
  end

  # GET /sky_tracks/new
  def new
    @sky_track = SkyTrack.new
  end

  # GET /sky_tracks/1/edit
  def edit
  end

  # POST /sky_tracks
  # POST /sky_tracks.json
  def create
    @sky_track = SkyTrack.new(sky_track_params)

    respond_to do |format|
      if @sky_track.save
        format.html { redirect_to @sky_track, notice: 'Sky track was successfully created.' }
        format.json { render action: 'show', status: :created, location: @sky_track }
      else
        format.html { render action: 'new' }
        format.json { render json: @sky_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sky_tracks/1
  # PATCH/PUT /sky_tracks/1.json
  def update
    respond_to do |format|
      if @sky_track.set(sky_track_params)
        format.html { redirect_to @sky_track, notice: 'Sky track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sky_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sky_tracks/1
  # DELETE /sky_tracks/1.json
  def destroy
    @sky_track.destroy
    respond_to do |format|
      format.html { redirect_to sky_tracks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sky_track
      @sky_track = SkyTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sky_track_params
      params.require(:sky_track).permit(:id_source)
    end
end
