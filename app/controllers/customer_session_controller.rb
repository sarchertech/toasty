class CustomerSessionController < ApplicationController
  #GET /customer_login
  def new
  end

  #POST /customer_login
  def create
    session[:customer_id] = nil
    @customer = @current_salon.customers.
      find_by_customer_number(params[:customer_number])

    if @customer
      session[:customer_id] = @customer.id
      redirect_to(new_salon_customer_tan_session_url(@current_salon))
    else

    end
  end

  #DELETE /customer_logout
  def destroy
    
  end
end
