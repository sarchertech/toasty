class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_account_and_current_salon, :set_current_user

  private
  
  def set_current_account_and_current_salon
    @current_account = Account.find_by_sub_domain!(request.subdomains.first)
    
    if params[:salon_id]
      @current_salon = @current_account.salons.find_by_identifier!(
        params[:salon_id])
    end
  end

  def set_current_user
    #set current user scoped to account unless admin
    if session[:user_id]
      begin  
        @current_user  = @current_account.users.find(session[:user_id])
      rescue
        potential_admin = User.find(session[:user_id])
        @current_user = potential_admin if potential_admin.security_level > 3    
      end
    end

    if !@current_user      
      session[:return_to] = request.fullpath
      redirect_to login_url
    elsif !authorized_to_work
      flash[:alert] = "You're not authorized to access that"
      redirect_to login_url
    end
  end

  def require_level(level)
    @current_user.security_level
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

  def authorized_to_work
    if @current_salon
      @current_user.can_work_here?(@current_salon.id) || @current_user.admin?
    else
      @current_user.access_all_locations? || @current_user.admin?
    end
  end
end
