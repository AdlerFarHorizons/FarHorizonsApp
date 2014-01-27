class BeaconTransmittersController < ApplicationController
  before_action :set_beacon_transmitter, only: [:show, :edit, :update, :destroy]

  # GET /beacon_transmitters
  # GET /beacon_transmitters.json
  def index
    @beacon_transmitters = BeaconTransmitter.all
  end

  # GET /beacon_transmitters/1
  # GET /beacon_transmitters/1.json
  def show
  end

  # GET /beacon_transmitters/new
  def new
    @beacon_transmitter = BeaconTransmitter.new
  end

  # GET /beacon_transmitters/1/edit
  def edit
  end

  # POST /beacon_transmitters
  # POST /beacon_transmitters.json
  def create
    @beacon_transmitter = BeaconTransmitter.new(beacon_transmitter_params)

    respond_to do |format|
      if @beacon_transmitter.save
        format.html { redirect_to @beacon_transmitter, notice: 'Beacon transmitter was successfully created.' }
        format.json { render action: 'show', status: :created, location: @beacon_transmitter }
      else
        format.html { render action: 'new' }
        format.json { render json: @beacon_transmitter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beacon_transmitters/1
  # PATCH/PUT /beacon_transmitters/1.json
  def update
    respond_to do |format|
      if @beacon_transmitter.set(beacon_transmitter_params)
        format.html { redirect_to @beacon_transmitter, notice: 'Beacon transmitter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @beacon_transmitter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beacon_transmitters/1
  # DELETE /beacon_transmitters/1.json
  def destroy
    @beacon_transmitter.destroy
    respond_to do |format|
      format.html { redirect_to beacon_transmitters_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beacon_transmitter
      @beacon_transmitter = BeaconTransmitter.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beacon_transmitter_params
      params.require(:beacon_transmitter).permit(:make, :model, :serial_no, :driver, :port, :call_sign, :persistent)
    end
end
