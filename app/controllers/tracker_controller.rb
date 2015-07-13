class TrackerController < ApplicationController
  
  def index
  end
  
  def login
    @admin = ( params[:passwd] == '33kmisasgoodasspace')
    render 'tracker/index'
  end

end