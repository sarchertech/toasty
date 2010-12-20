class CustomersController < ApplicationController
  #GET /customers
  #GET /salons/1/customers
  def index
    @customers = scope.customers
  end

  def show
    @customer = scope.customers.find(params[:id])
  end

  private

  def scope
    @current_salon ? @current_salon : @current_account
  end
end
