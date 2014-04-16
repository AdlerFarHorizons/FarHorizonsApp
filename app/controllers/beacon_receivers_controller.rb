class BeaconReceiversController < ApplicationController
  before_action :set_beacon_receiver, only: [:show, :edit, :update, :destroy]

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
