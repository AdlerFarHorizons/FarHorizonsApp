class GroundTracksController < ApplicationController
  before_action :set_ground_track, only: [:show, :edit, :update, :destroy]

  # GET /ground_tracks
  # GET /ground_tracks.json
  def index
    @ground_tracks = GroundTrack.all
  end

  # GET /ground_tracks/1
  # GET /ground_tracks/1.json
  def show
  end

  # GET /ground_tracks/new
  def new
    @ground_track = GroundTrack.new
  end

  # GET /ground_tracks/1/edit
  def edit
  end

  # POST /ground_tracks
  # POST /ground_tracks.json
  def create
    @ground_track = GroundTrack.new(ground_track_params)

    respond_to do |format|
      if @ground_track.save
        format.html { redirect_to @ground_track, notice: 'Ground track was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ground_track }
      else
        format.html { render action: 'new' }
        format.json { render json: @ground_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ground_tracks/1
  # PATCH/PUT /ground_tracks/1.json
  def update
    respond_to do |format|
      if @ground_track.set(ground_track_params)
        format.html { redirect_to @ground_track, notice: 'Ground track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ground_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ground_tracks/1
  # DELETE /ground_tracks/1.json
  def destroy
    @ground_track.destroy
    respond_to do |format|
      format.html { redirect_to ground_tracks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ground_track
      @ground_track = GroundTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ground_track_params
      params.require(:ground_track).permit(:id_source)
    end
end
