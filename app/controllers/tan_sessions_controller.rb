class TanSessionsController < ApplicationController
  # GET /salons/:salon_id/tan_sessions/new
  def new
    @beds = @current_salon.beds.order("bed_number ASC")
    @tan_session = TanSession.new
  end
end
