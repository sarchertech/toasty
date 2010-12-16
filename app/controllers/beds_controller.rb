class BedsController < ApplicationController
  before_filter :set_current_salon
  
  # GET /beds
  def index
    @beds = @current_salon.beds 
  end

  private

  def set_current_salon
    @current_salon = @current_account.salons.find_by_identifier!(
      params[:salon_id])
  end
end
