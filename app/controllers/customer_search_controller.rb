class CustomerSearchController < ApplicationController
  #POST /customer_search
  def create
    if search_empty?
      @customers = scope.customers.limit(30)
    else
      @customers = scope.customers.by_name(name_array).by_level(level).limit(30)
    end

    render :partial => "customers/customer_table"
  end

  private

  def search_empty?
    return true unless params[:search]

    params[:search].values.each do |val|
      break unless val.blank?
    end
  end

  def name_array
    return "" if params[:search][:name].blank?
    params[:search][:name][0..29].split(' ')
  end

  def level
    #return [] if params[:search][:level].blank?
    params[:search][:level]
  end
end
