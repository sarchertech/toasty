class CustomerSessionController < ApplicationController
  #GET /customer_login
  def new
    session[:customer_id] = nil
  end

  #POST /customer_login
  def create
    session[:customer_id] = nil
    @customer = @current_salon.customers.
      find_by_customer_number(params[:customer_number])

    @tan_session = @customer.tan_sessions.last if @customer

    if @customer == nil
      flash.now[:alert] = "can't find a customer with that keyfob number" 
      render :action => "new"
    elsif today?
      flash.now[:alert] = "you've already tanned today"
      render :action => "new"
    elsif too_soon?
      flash.now[:alert] = "it's been less than 6 hours since you last tanned"
      render :action => "new"
    else
      session[:customer_id] = @customer.id
      redirect_to(new_salon_customer_tan_session_url(@current_salon))
    end
  end

  #DELETE /customer_logout
  def destroy
    
  end

  private

  def today?
    @tan_session && (@tan_session.created_at.to_date == Time.zone.now.to_date)
  end

  def too_soon?
    @tan_session && (@tan_session.created_at > 6.hours.ago)
  end
end
