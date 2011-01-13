class CustomerSearchController < ApplicationController
  #POST /customer_search
  def create
    @customers = scope.customers.filter(name, level, type).limit(30).
                       by_tanned(tanned)

    render :partial => "customers/customer_table"
  end

  private

  def type
    search[:type]
  end

  def name
    search[:name]
  end

  def level
    search[:level]
  end

  def tanned
    search[:tanned]
  end

  def search
    params[:search] || {}
  end
end
