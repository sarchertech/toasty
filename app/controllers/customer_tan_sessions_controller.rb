class CustomerTanSessionsController < ApplicationController
  # GET /salons/:salon_id/tan_sessions/new
  def new
    @beds = @current_salon.beds
    @tan_session = TanSession.new
    @customer = Customer.find(session[:customer_id])
  end
end
