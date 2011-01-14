class SessionController < ApplicationController
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
    redirect_to(new_salon_tan_session_url(@current_account.salons.first))
  end
end
