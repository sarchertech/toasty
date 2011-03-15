class SessionController < ApplicationController
  skip_before_filter :set_current_user, :set_current_account_and_current_salon
  before_filter :session_controller_set_current_account

  # GET /login
  def new
  end

  # POST /login
  def create
    session[:user_id] = nil
    @user = @current_account.users.find_by_login(params[:login]) if @current_account

    unless @user
      potential_admin = User.find_by_login(params[:login])
      
      if potential_admin && potential_admin.security_level > 3
        @user = potential_admin
      end
    end

    if locked_out? || !authenticated?
      failed_login_redirect 
    elsif authenticated?
      session[:user_id] = @user.id
      
      successful_login_redirect
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    redirect_to(login_url)
  end

  private

  def session_controller_set_current_account
     @current_account = Account.find_by_sub_domain(request.subdomains.first)
  end

  def authenticated?
    @user && @user.has_password?(params[:password])
  end

  def locked_out?
    @user && @user.too_many_tries?
  end

  def failed_login_redirect
    if locked_out? 
      flash[:alert] = "Too many invalid login attempts. You must 
        #{@user.how_long} before you can login."
    elsif !authenticated?
      flash[:alert] = "login/pass combination does not match"
    end

    redirect_to(login_url)
  end

  def successful_login_redirect
    if session[:return_to]
      redirect_to(session[:return_to])
      session[:return_to] = nil
    else      
      #rescue in case there is not @current_account (loggin in to /accounts)
      #or there is one but the current user doesnt belong to it and is an admin
      begin
        current_user = @current_account.users.find(session[:user_id])
        redirect_salon = current_user.salon || @current_account.salons.first
        redirect_to new_salon_tan_session_url(redirect_salon)
      rescue
        potential_admin = User.find(session[:user_id])
        redirect_to accounts_url if potential_admin.security_level > 3 
      end
    end 
  end
end
