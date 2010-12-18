class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_account_and_current_salon

  private
  
  def set_current_account_and_current_salon
    @current_account = Account.find_by_sub_domain!(request.subdomains.first)
    
    if params[:salon_id]
      @current_salon = @current_account.salons.find_by_identifier!(
        params[:salon_id])
    end
  end
end
