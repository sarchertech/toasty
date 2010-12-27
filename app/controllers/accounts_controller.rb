class AccountsController < ApplicationController
  skip_before_filter :set_current_account_and_current_salon

  # GET /accounts
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  def show
    @account = Account.find(params[:id])
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
    @account = Account.find(params[:id])
  end

  # POST /accounts
  def create
    @account = Account.new(params[:account])
    respond_to do |format|
      if @account.save
        format.html {redirect_to(@account, 
                       :notice => "Account was successfully created")} 
      else
        format.html {render :action => "new"}
      end
    end
  end

  # PUT /accounts/1
  def update
    @account = Account.find(params[:id])

    respond_to do |format|
      if @account.update_attributes(params[:account])
        format.html {redirect_to(@account,
                       :notice => "Account was successfully updated")}
      else
        format.html {render :action => "edit"}
      end
    end
  end

  # DELETE /accounts/1
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html {redirect_to(accounts_url)}
    end
  end
end
