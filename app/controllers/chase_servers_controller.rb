class ChaseServersController < ApplicationController
  before_action :set_chase_server, only: [:show, :edit, :update, :destroy]

  # GET /chase_servers
  # GET /chase_servers.json
  def index
    @chase_servers = ChaseServer.all
  end

  # GET /chase_servers/1
  # GET /chase_servers/1.json
  def show
  end

  # GET /chase_servers/new
  def new
    @chase_server = ChaseServer.new
  end

  # GET /chase_servers/1/edit
  def edit
  end

  # POST /chase_servers
  # POST /chase_servers.json
  def create
    @chase_server = ChaseServer.new(chase_server_params)

    respond_to do |format|
      if @chase_server.save
        format.html { redirect_to @chase_server, notice: 'Chase server was successfully created.' }
        format.json { render action: 'show', status: :created, location: @chase_server }
      else
        format.html { render action: 'new' }
        format.json { render json: @chase_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chase_servers/1
  # PATCH/PUT /chase_servers/1.json
  def update
    respond_to do |format|
      if @chase_server.set(chase_server_params)
        format.html { redirect_to @chase_server, notice: 'Chase server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @chase_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chase_servers/1
  # DELETE /chase_servers/1.json
  def destroy
    @chase_server.destroy
    respond_to do |format|
      format.html { redirect_to chase_servers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chase_server
      @chase_server = ChaseServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chase_server_params
      params.require(:chase_server).permit(:hostname, :make, :model, :serial_no, :sw_version, :location_device_id, :beacon_receiver_ids, :router_id, :persistent)
    end
end
