class ChaseVehiclesController < ApplicationController
  before_action :set_chase_vehicle, only: [:show, :edit, :update, :destroy,
    :location]

  # GET /chase_vehicle_location/1
  def location
    time = params[:after_time] ? Time.parse(params[:after_time]) : Time.at(0)
    track = @chase_vehicle.ground_track
    point = track ? track.points.where( :time => { :$gt => time } )
                      .sort( :time, :asc ).last
                  : nil
    render json:  
          point ? { :time => point.time,:lat => point.lat, :lon => point.lon,
                    :alt => point.alt, :heading => point.heading, 
                    :vg => point.vg, :ident => point.ident }
                : nil
  end
  
  # GET /chase_vehicles
  # GET /chase_vehicles.json
  def index
    @chase_vehicles = ChaseVehicle.all
  end

  # GET /chase_vehicles/1
  # GET /chase_vehicles/1.json
  def show
  end

  # GET /chase_vehicles/new
  def new
    @chase_vehicle = ChaseVehicle.new
  end

  # GET /chase_vehicles/1/edit
  def edit
    @object = @chase_vehicle
    render "common/edit"
  end

  # POST /chase_vehicles
  # POST /chase_vehicles.json
  def create
    @chase_vehicle = ChaseVehicle.new(chase_vehicle_params)

    respond_to do |format|
      if @chase_vehicle.save
        format.html { redirect_to :back, notice: 'Chase vehicle was successfully created.' }
        format.json { render action: 'show', status: :created, location: @chase_vehicle }
      else
        format.html { render action: 'new' }
        format.json { render json: @chase_vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chase_vehicles/1
  # PATCH/PUT /chase_vehicles/1.json
  def update
    respond_to do |format|
      if @chase_vehicle.set(chase_vehicle_params)
        format.html { redirect_to :back, notice: 'Chase vehicle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @chase_vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chase_vehicles/1
  # DELETE /chase_vehicles/1.json
  def destroy
    @chase_vehicle.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chase_vehicle
      @chase_vehicle = ChaseVehicle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chase_vehicle_params
      params.require(:chase_vehicle).permit(:description, :ident, 
                                            :mission_id, :chase_server_id )
    end
end