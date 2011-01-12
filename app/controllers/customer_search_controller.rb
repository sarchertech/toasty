class CustomerSearchController < ApplicationController
  #POST /customer_search
  def create
    if search_empty?
      @customers = scope.customers.limit(30).order('created_at DESC')
    else      
      name = params[:search][:name].split(' ')
      first = name[0]
      second = name[1]

      str1 = "(first_name LIKE :f AND last_name LIKE :s) OR "
      str2 = "(first_name LIKE :s AND last_name LIKE :f)"
      @customers = scope.customers.where(str1 + str2, 
        :f => "#{first}%", 
        :s => "#{second}%").limit(30).order('created_at DESC')
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
end
