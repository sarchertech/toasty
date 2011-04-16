class CustomerSessionController < ApplicationController
  #new page can sit w/o reloading for a long time, also no login is required to
  # to access this so CSRF is moot
  skip_before_filter :verify_authenticity_token, :set_current_user

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
    
    flash_and_render_or_redirect
  end

  #DELETE /customer_logout
  def destroy
    
  end

  private

  def flash_and_render_or_redirect
    if @customer == nil
      flash.now[:alert] = "can't find a customer with that keyfob number" 
    elsif !@customer.can_tan?
      flash[:alert] = @customer.errors[:tan].first
    elsif today?
      flash.now[:alert] = "you've already tanned today"
    elsif too_soon?
      flash.now[:alert] = "it's been less than 6 hours since you last tanned"
    else
      redirect = true
    end
    
    if redirect
      session[:customer_id] = @customer.id
      redirect_to(new_salon_customer_tan_session_url(@current_salon))
    else
      render :action => "new"
    end
  end

  def today?
    @tan_session && (@tan_session.created_at.to_date == Time.zone.now.to_date)
  end

  def too_soon?
    @tan_session && (@tan_session.created_at > 6.hours.ago)
  end
end
