class CustomerJsonSearchController < ApplicationController
  #POST /customer_json_search
  def create
    if params[:name].present?
      @customers = scope.customers.by_name(params[:name]).limit(10)
    end

    respond_to do |format|
      if @customers.present?
        customers =  @customers.to_json(:only => [:id, :first_name, :last_name]) 
        format.js {render :json => customers }   
      else
        format.js {render :text => "customer not found", :status => 404}
      end
    end
  end
end
