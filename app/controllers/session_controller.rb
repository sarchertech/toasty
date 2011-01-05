class SessionController < ApplicationController
  # GET /login
  def index
  end

  # POST /login
  def create
    @user = @current_account.users.find_by_login(params[:login])

    if @user && @user.has_password?(params[:password])
      session[:user_id] = @user.id
      redirect_to("/")
    else
      render :action => "new", 
             :error => "login password combination does not match"
    end
  end
end
