class SessionController < ApplicationController
  skip_before_filter :set_current_user

  # GET /login
  def new
  end

  # POST /login
  def create
    session[:user_id] = nil
    @user = @current_account.users.find_by_login(params[:login])

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
      current_user = @current_account.users.find(session[:user_id])
      redirect_salon = current_user.salon || @current_account.salons.first
      redirect_to new_salon_tan_session_url(redirect_salon)
    end
  end
end
