class LocationDevicesController < ApplicationController
  before_action :set_location_device, only: [:show, :edit, :update, :destroy]

  # GET /location_devices
  # GET /location_devices.json
  def index
    @location_devices = LocationDevice.all
  end

  # GET /location_devices/1
  # GET /location_devices/1.json
  def show
  end

  # GET /location_devices/new
  def new
    @location_device = LocationDevice.new
  end

  # GET /location_devices/1/edit
  def edit
  end

  # POST /location_devices
  # POST /location_devices.json
  def create
    @location_device = LocationDevice.new(location_device_params)

    respond_to do |format|
      if @location_device.save
        format.html { redirect_to @location_device, notice: 'Location device was successfully created.' }
        format.json { render action: 'show', status: :created, location: @location_device }
      else
        format.html { render action: 'new' }
        format.json { render json: @location_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /location_devices/1
  # PATCH/PUT /location_devices/1.json
  def update
    respond_to do |format|
      if @location_device.update(location_device_params)
        format.html { redirect_to @location_device, notice: 'Location device was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @location_device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /location_devices/1
  # DELETE /location_devices/1.json
  def destroy
    @location_device.destroy
    respond_to do |format|
      format.html { redirect_to location_devices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location_device
      @location_device = LocationDevice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_device_params
      params.require(:location_device).permit(:make, :model, :serial_no, :driver, :port, :persistent)
    end
end
