class SessionController < ApplicationController
  # GET /login
  def new
  end

  # POST /login
  def create
    session[:user_id] = nil
    @user = @current_account.users.find_by_login(params[:login])

    if @user && @user.too_many_tries?
      flash.now[:alert] = "Too many invalid login attempts. You 
                           must #{@user.how_long} before you can login."
      
      render :action => "new"
    elsif @user && @user.has_password?(params[:password])
      session[:user_id] = @user.id
      
      redirect_to("/")
    else
      flash.now[:alert] = "login/password combination does not match"
      
      render :action => "new"  
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    redirect_to("login_url")
  end
end
