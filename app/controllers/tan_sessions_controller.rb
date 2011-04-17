class TanSessionsController < ApplicationController
  # GET /salons/:salon_id/tan_sessions/new
  def new
    @beds = @current_salon.beds.order("bed_number ASC")
    @tan_session = TanSession.new
  end

  #POST /salons/:salon_id/tan_session
  def create
    @tan_session = TanSession.new
    @bed = @current_salon.beds.find_by_bed_number(params[:tan_session][:bed_id])
    @customer = @current_salon.customers.find(params[:tan_session][:customer_id])

    @tan_session.minutes = params[:tan_session][:minutes]
    @tan_session.bed_id = @bed.id
    @tan_session.customer_id = @customer.id    
    @tan_session.salon_id = @current_salon.id    

    @tan_session.customer.tan

    #TODO fix this to provide proper status codes
    if @tan_session.customer.save && @tan_session.save
      render :text => "new"
    else
      render :text => "new"
    end
  end
end
