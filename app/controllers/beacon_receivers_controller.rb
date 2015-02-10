class BeaconReceiversController < ApplicationController
  before_action :set_beacon_receiver, only: 
    [:show, :edit, :update, :destroy, :start, :stop]


  # GET /beacon_receivers
  # GET /beacon_receivers.json
  def index
    @beacon_receivers = BeaconReceiver.all
  end

  # GET /beacon_receivers/1
  # GET /beacon_receivers/1.json
  def show
  end

  # GET /beacon_receivers/new
  def new
    @beacon_receiver = BeaconReceiver.new
  end

  # GET /beacon_receivers/1/edit
  def edit
  end

  # POST /beacon_receivers
  # POST /beacon_receivers.json
  def create
    @beacon_receiver = BeaconReceiver.new(beacon_receiver_params)

    respond_to do |format|
      if @beacon_receiver.save
        format.html { redirect_to @beacon_receiver, notice: 'Beacon receiver was successfully created.' }
        format.json { render action: 'show', status: :created, location: @beacon_receiver }
      else
        format.html { render action: 'new' }
        format.json { render json: @beacon_receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beacon_receivers/1
  # PATCH/PUT /beacon_receivers/1.json
  def update
    respond_to do |format|
      if @beacon_receiver.set(beacon_receiver_params)
        format.html { redirect_to @beacon_receiver, notice: 'Beacon receiver was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @beacon_receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beacon_receivers/1
  # DELETE /beacon_receivers/1.json
  def destroy
    @beacon_receiver.destroy
    respond_to do |format|
      format.html { redirect_to beacon_receivers_url }
      format.json { head :no_content }
    end
  end

  # /beacon_receivers/start/1
  # /beacon_receivers/start/1.json
  def start
    if @beacon_receiver
      driver = @beacon_receiver.driver
      host = "http://#{request.host_with_port()}"
      bcnrcvr = @beacon_receiver.id.to_s
      speedup = params[:speedup]
      temp = ChaseServer.where(:beacon_receiver_ids => bcnrcvr ).first
      puts "ChaseServer:#{temp.id}"
      temp = ChaseVehicle.where( :chase_server_id => temp.id.to_s ).first
      puts "ChaseVehicle:#{temp.id}"
      unless @beacon_receiver.driver_pid
        if ( (serv = ChaseServer.where( :beacon_receiver_ids => bcnrcvr ).first) &&
             (veh = ChaseVehicle.where( :chase_server_id => serv.id.to_s ).first) )
          Process.detach( spawn( 
              "bin/#{@beacon_receiver.driver} #{host} #{bcnrcvr} '#{RedisConnection.get('beacon_filter')}' #{speedup} " ) )
          sleep 2
          pid = `pgrep -f "[r]uby bin\/#{@beacon_receiver.driver}"`.chomp     
          puts "PID:#{pid}"
          # Test first if process was spawned and then if it's still running
          if pid && `ps -p "#{pid.to_s}" -o pid --no-header`.to_i > 0
            @beacon_receiver.driver_pid = pid
            @beacon_receiver.save
            render :inline => "Beacon Receiver #{@beacon_receiver.id} driver started as PID:#{pid}."
          else
            render :inline => "Could not start Beacon Receiver #{@beacon_receiver.id} driver.", 
                    status: :accepted
          end
        else
          render :inline => "Failed: Beacon Receiver #{@beacon_receiver.id} " +
                            "not attached to a ChaseServer assigned to " +
                            "a ChaseVehicle.", status: :unprocessable_entity
        end
      else
        render :inline => "Failed: Beacon Receiver #{@beacon_receiver.id} " +
                          "driver already running as PID:#{@beacon_receiver.driver_pid}",
                          status: :unprocessable_entity
      end
    else
      render :inline => "Failed: Beacon Receiver #{params[:id]} not found.",
             status: :not_found
    end
  end
  
  # /beacon_receivers/stop/1
  # /beacon_receivers/stop/1.json
  def stop
    if @beacon_receiver
      if (pid = @beacon_receiver.driver_pid) && 
         `ps -p "#{pid.to_s}" -o pid --no-header`.to_i > 0
        Process.kill( 'TERM', @beacon_receiver.driver_pid )
        @beacon_receiver.driver_pid = nil
        @beacon_receiver.save
        render :inline => "Beacon Receiver #{@beacon_receiver.id} " +
                          "driver PID:#{@beacon_receiver.driver_pid} stopped."
      else
        @beacon_receiver.driver_pid = nil
        @beacon_receiver.save
        render :inline => "Failed: Beacon Receiver #{@beacon_receiver.id} " +
                          "driver already stopped",
                          status: :unprocessable_entity
      end
    else
      render :inline => "Failed: Beacon Receiver #{params[:id]} not found.",
             status: :not_found
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beacon_receiver
      @beacon_receiver = BeaconReceiver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beacon_receiver_params
      params.require(:beacon_receiver).permit(:make, :model, :serial_no, :driver, :port)
    end
end
