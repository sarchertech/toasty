class UsersController < ApplicationController
  #GET /users
  #GET /salons/1/users
  def index
    @users = scope.users
  end
  
  #GET /users/1
  #GET /salons/1/users/1
  def show
    @user = scope.users.find(params[:id])
  end
  
  #GET /users/new
  #GET /salons/1/users/new
  def new
    @user = User.new    
  end
  
  #GET /users/1/edut
  #GET /salons/1/users/1/edit
  def edit
    @user = scope.users.find(params[:id])
  end
  
  #POST /users
  #POST /salons/1/users
  def create
    @user = User.new(params[:user])
    @user.account_id = @current_account.id
    @user.salon_id = current_salon(user_salon_id).id

    respond_to do |format|
      if @user.save
        format.html {redirect_to(path(@user), 
                      :notice => "User was successfully created")}
      else
        format.html {render :action => "new"}
      end
    end
  end

  # PUT /users/1
  # PUT /salons/1/users/1
  def update
    @user = scope.users.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html {redirect_to(path(@user), 
                      :notice => "User was successfully updated")}
      else
        format.html {render :action => "edit"}
      end
    end
  end

  # DELETE /users/1
  # DELETE /salons/1/users/1
  def destroy
    @user = scope.users.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html {redirect_to(plural_url("users") )}
    end
  end

  private

  def user_salon_id
    params[:user][:salon_id] rescue nil
  end
end
