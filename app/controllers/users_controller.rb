class UsersController < ApplicationController
  before_filter :require_manager, :only => [:new, :create]
  before_filter :authorized_to_edit_user, :only => [:edit, :update, :destroy]
    
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
    #should already be set in before filter
    @user ||= scope.users.find(params[:id])
  end
  
  #POST /users
  #POST /salons/1/users
  def create
    @user = User.new(params[:user])
    @user.account_id = @current_account.id
    @user.salon_id = current_salon(user_salon_id).id
    @user.aspiring_editor_security_level = @current_user.security_level

    unless @current_user.access_all_locations?
      @user.aspiring_editor_cant_access_all = true 
    end

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
    @user ||= scope.users.find(params[:id])
    @user.attributes = params[:user]
    @user.aspiring_editor_security_level = @current_user.security_level 
    
    unless @current_user.access_all_locations?
      @user.aspiring_editor_cant_access_all = true 
    end

    respond_to do |format|
      if @user.save
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
    @user ||= scope.users.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html {redirect_to(plural_url("users") )}
    end
  end

  private

  def user_salon_id
    params[:user][:salon_id] rescue nil
  end
  
  def authorized_to_edit_user
    unless current_user_higher_level_or_self?
      flash[:alert] = "You don't have permission" 
      redirect_to path(@user)
    end  
  end

  def current_user_higher_level_or_self?
    @user = scope.users.find(params[:id])
    current_user_higher? || current_user_self?    
  end

  def current_user_higher?
    @current_user.security_level > @user.security_level
  end

  def current_user_self?
    @current_user == @user
  end
end
