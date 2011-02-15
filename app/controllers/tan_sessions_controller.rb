class TanSessionsController < ApplicationController
  before_filter :set_current_user

  # GET /salons/:salon_id/tan_sessions/new
  def new
    @beds = @current_salon.beds.order("bed_number ASC")
    @tan_session = TanSession.new
  end
end
