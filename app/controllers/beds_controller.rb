class BedsController < ApplicationController
  # GET /beds
  def index
    @beds = @current_salon.beds 
  end

  def show
    @bed = @current_salon.beds.find(params[:id])
  end
end
