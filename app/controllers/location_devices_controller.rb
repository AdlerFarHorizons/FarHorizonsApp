class LocationDevicesController < ApplicationController
  before_action :set_location_device, only: 
    [:show, :edit, :update, :destroy, :start, :stop]

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
      if @location_device.set(location_device_params)
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
  
  # /location_devices/start/1
  # /location_devices/start/1.json
  def start
    if @location_device
      driver = @location_device.driver
      host = "http://#{request.host_with_port()}"
      loc = @location_device.id.to_s      
      temp = ChaseServer.where(:location_device_id => loc ).first
      speedup = params[:speedup]
      temp = ChaseVehicle.where( :chase_server_id => temp.id.to_s ).first
      
      unless @location_device.driver_pid
        if ( (serv = ChaseServer.where( :location_device_id => loc ).first) &&
             (veh = ChaseVehicle.where( :chase_server_id => serv.id.to_s ).first) )
          Process.detach( spawn( 
              "bin/#{@location_device.driver} #{host} #{loc} #{veh.ident} #{speedup}" ) )
          sleep 2
          pid = `pgrep -f "[r]uby bin\/#{@location_device.driver}"`.chomp     
          # Test first if process was spawned and then if it's still running
          if pid && `ps -p "#{pid.to_s}" -o pid --no-header`.to_i > 0
            @location_device.driver_pid = pid
            @location_device.save
            render :inline => "Location Device #{@location_device.id} " +
                              "driver started as PID:#{pid}."
          else
            render :inline => "Could not start Location Device " +
                              "#{@location_device.id} driver."
          end
        else
          render :inline => "Failed: Location Device #{@location_device.id} " +
                            "not attached to a ChaseServer assigned to " +
                            "a ChaseVehicle."
        end
      else
        render :inline => "Failed: Location Device #{@location_device.id} " +
                          "driver already running as " +
                          "PID:#{@location_device.driver_pid}"
      end
    else
      render :inline => "Failed: Location Device #{params[:id]} not found."
    end
  end
  
  # /location_devices/stop/1
  # /location_devices/stop/1.json
  def stop
    if @location_device
      if (pid = @location_device.driver_pid) && 
         `ps -p "#{pid.to_s}" -o pid --no-header`.to_i > 0
        Process.kill( 'TERM', @location_device.driver_pid )
        @location_device.driver_pid = nil
        @location_device.save
        render :inline => "Location Device #{@location_device.id} " +
                          "driver PID:#{@location_device.driver_pid} stopped."
      else
        @location_device.driver_pid = nil
        @location_device.save
        render :inline => "Failed: Location Device #{@location_device.id} " +
                          "driver already stopped"
      end
    else
      render :inline => "Failed: Location Device #{params[:id]} not found."
    end
    # Delete previous simulated tracks if sim driver
    if @location_device.driver.end_with?( 'sim' )
      GroundTrack.where( :id_source => @location_device.id.to_s ).each { |x| x.destroy() }
    end
      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location_device
      @location_device = LocationDevice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_device_params
      params.require(:location_device).permit(:make, :model, :serial_no, :driver, :port)
    end
end
