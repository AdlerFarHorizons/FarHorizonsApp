class PredictedTracksController < ApplicationController
  before_action :set_predicted_track, only: [:show, :edit, :update, :destroy]

  # GET /predicted_tracks
  # GET /predicted_tracks.json
  def index
    @predicted_tracks = PredictedTrack.all
  end

  # GET /predicted_tracks/1
  # GET /predicted_tracks/1.json
  def show
  end

  # GET /predicted_tracks/new
  def new
    @predicted_track = PredictedTrack.new
  end

  # GET /predicted_tracks/1/edit
  def edit
  end

  # POST /predicted_tracks
  # POST /predicted_tracks.json
  def create
    @predicted_track = PredictedTrack.new(predicted_track_params)

    respond_to do |format|
      if @predicted_track.save
        format.html { redirect_to :back, notice: 'Predicted track was successfully created.' }
        format.json { render action: 'show', status: :created, location: @predicted_track }
      else
        format.html { render action: 'new' }
        format.json { render json: @predicted_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /predicted_tracks/1
  # PATCH/PUT /predicted_tracks/1.json
  def update
    respond_to do |format|
      if @predicted_track.set(predicted_track_params)
        format.html { redirect_to :back, notice: 'Predicted track was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @predicted_track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /predicted_tracks/1
  # DELETE /predicted_tracks/1.json
  def destroy
    @predicted_track.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_predicted_track
      @predicted_track = PredictedTrack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def predicted_track_params
      params.require(:predicted_track).permit(:source, :file_path, :platform_id)
    end
end
