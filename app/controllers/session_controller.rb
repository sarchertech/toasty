class SessionController < ApplicationController
  # GET /login
  def new
  end

  # POST /login
  def create
    session[:user_id] = nil
    @user = @current_account.users.find_by_login(params[:login])

    if @user && @user.too_many_tries?
      flash[:alert] = "Too many invalid login attempts. You 
                           must #{@user.how_long} before you can login."
      
      redirect_to(login_url)
    elsif @user && @user.has_password?(params[:password])
      session[:user_id] = @user.id
      
      redirect_to("/")
    else
      flash[:alert] = "login/password combination does not match"
      
      redirect_to(login_url)  
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    redirect_to(login_url)
  end
end
