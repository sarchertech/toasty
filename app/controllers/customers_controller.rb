class CustomersController < ApplicationController
  #GET /customers
  #GET /salons/1/customers
  def index
    @customers = scope.customers.limit(30)
  end
  
  #GET /customers/1
  #GET /salons/1/customers/1
  def show
    @customer = scope.customers.find(params[:id])
  end
  
  #GET /customers/new
  #GET /salons/1/customers/new
  def new
    @customer = Customer.new    
  end
  
  #GET /customers/1/edut
  #GET /salons/1/customers/1/edit
  def edit
    @customer = scope.customers.find(params[:id])
  end
  
  #POST /customers
  #POST /salons/1/customers
  def create
    @customer = Customer.new(params[:customer])
    @customer.account_id = @current_account.id
    @customer.salon_id = current_salon(customer_salon_id).id

    respond_to do |format|
      if @customer.save
        format.html {redirect_to(path(@customer), 
                      :notice => "Customer was successfully created")}
      else
        format.html {render :action => "new"}
      end
    end
  end

  # PUT /customers/1
  # PUT /salons/1/customers/1
  def update
    @customer = scope.customers.find(params[:id])
    
    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html {redirect_to(path(@customer), 
                      :notice => "Customer was successfully updated")}
      else
        format.html {render :action => "edit"}
      end
    end
  end

  # DELETE /customers/1
  # DELETE /salons/1/customers/1
  def destroy
    @customer = scope.customers.find(params[:id])
    @customer.destroy

    respond_to do |format|
      format.html {redirect_to(plural_url("customers") )}
    end
  end

  private

  def customer_salon_id
    params[:customer][:salon_id] rescue nil
  end
end
