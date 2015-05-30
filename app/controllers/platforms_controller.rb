class PlatformsController < ApplicationController
  before_action :set_platform, only: [:show, :edit, :update, :destroy, :tracks]

 # GET /tracks/1
  def tracks
    time = params[:after_time] ? Time.parse(params[:after_time]) : Time.at(0)
    tracks = @platform.sky_tracks
    result = tracks.collect do |track|
      points = track.points.where( :time => { :$gt => time } ).sort( :time, :asc )
      points.count == 0 ? nil :
        { :ident => track.ident, 
          :last_time => points.last.time.utc.to_s, 
          :points => points.collect { |point| {
            :time => point.time, :lat => point.lat, :lon => point.lon,
            :alt => point.alt, :heading => point.heading, :vg => point.vg,
            :ident => point.ident } }
        }
      
    end
    render json: result
  end
  
  # GET /platforms
  # GET /platforms.json
  def index
    @platforms = Platform.all
  end

  # GET /platforms/1
  # GET /platforms/1.json
  def show
  end

  # GET /platforms/new
  def new
    @platform = Platform.new
  end

  # GET /platforms/1/edit
  def edit
  end

  # POST /platforms
  # POST /platforms.json
  def create
    @platform = Platform.new(platform_params)

    respond_to do |format|
      if @platform.save
        format.html { redirect_to :back, notice: 'Platform was successfully created.' }
        format.json { render action: 'show', status: :created, location: @platform }
      else
        format.html { render action: 'new' }
        format.json { render json: @platform.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /platforms/1
  # PATCH/PUT /platforms/1.json
  def update
    respond_to do |format|
      if @platform.set(platform_params)
        format.html { redirect_to :back, notice: 'Platform was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @platform.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /platforms/1
  # DELETE /platforms/1.json
  def destroy
    @platform.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_platform
      @platform = Platform.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def platform_params
      params.require(:platform).permit(:description, :ident, :mission_id,
                                       :platform_server_id, :beacon_ids)
    end
end
