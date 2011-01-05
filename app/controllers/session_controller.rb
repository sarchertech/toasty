class SessionController < ApplicationController
  # GET /login
  def index
  end

  # POST /login
  def create
    @user = @current_account.users.find_by_login(params[:login])

    if @user && @user.too_many_tries?
      err = "You have attempted to log in with an incorrect password too many
             times. You must #{@user.how_long} before you can login."
      
      render :action => "new", :error => err
    elsif @user && @user.has_password?(params[:password])
      session[:user_id] = @user.id
      
      redirect_to("/")
    else
      err = "login/password combination does not match"
      
      render :action => "new", :error => err    
    end
  end

  # DELETE /logout
  def destroy
    session[:user_id] = nil
    redirect_to("login_url")
  end
end
