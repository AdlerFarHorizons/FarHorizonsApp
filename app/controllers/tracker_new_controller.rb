class TrackerNewController < ApplicationController

  def index
  end

  def login
    @admin = ( params[:passwd] == '33kmisasgoodasspace')
    render 'tracker_new/index'
  end

end
