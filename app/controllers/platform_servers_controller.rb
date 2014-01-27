class PlatformServersController < ApplicationController
  before_action :set_platform_server, only: [:show, :edit, :update, :destroy]

  # GET /platform_servers
  # GET /platform_servers.json
  def index
    @platform_servers = PlatformServer.all
  end

  # GET /platform_servers/1
  # GET /platform_servers/1.json
  def show
  end

  # GET /platform_servers/new
  def new
    @platform_server = PlatformServer.new
  end

  # GET /platform_servers/1/edit
  def edit
  end

  # POST /platform_servers
  # POST /platform_servers.json
  def create
    @platform_server = PlatformServer.new(platform_server_params)

    respond_to do |format|
      if @platform_server.save
        format.html { redirect_to @platform_server, notice: 'Platform server was successfully created.' }
        format.json { render action: 'show', status: :created, location: @platform_server }
      else
        format.html { render action: 'new' }
        format.json { render json: @platform_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /platform_servers/1
  # PATCH/PUT /platform_servers/1.json
  def update
    respond_to do |format|
      if @platform_server.set(platform_server_params)
        format.html { redirect_to @platform_server, notice: 'Platform server was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @platform_server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /platform_servers/1
  # DELETE /platform_servers/1.json
  def destroy
    @platform_server.destroy
    respond_to do |format|
      format.html { redirect_to platform_servers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_platform_server
      @platform_server = PlatformServer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def platform_server_params
      params.require(:platform_server).permit(:hostname, :make, :model, :serial_no, :sw_version, :persistent)
    end
end
