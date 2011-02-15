class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_account_and_current_salon

  private
  
  def set_current_account_and_current_salon
    @current_account = Account.find_by_sub_domain!(request.subdomains.first)
    
    if params[:salon_id]
      @current_salon = @current_account.salons.find_by_identifier!(
        params[:salon_id])
    end
  end

  def set_current_user
    if session[:user_id]
      @current_user = @current_salon.users.find(session[:user_id])
    end

    unless @current_user
      session[:return_to] = request.fullpath
      redirect_to login_url    
    end
  end

  def scope
    @current_salon || @current_account
  end

  def current_salon(params)
    # if at @current_salon not set -- returns salon supplied customer form
    @current_salon || @current_account.salons.find_by_identifier!(params)
  end

  def path(instance)
    [@current_salon, instance] || instance
  end
 
  def plural_url(plural_string)
    if @current_salon
      eval("salon_#{plural_string}_url(@current_salon)")
    else
      eval("#{plural_string}_url")
    end
  end
end
