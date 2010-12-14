class SalonsController < ApplicationController
  # GET /salons
  def index
    @salons = @current_account.salons
  end

  # GET /salons/1
  def show
    @salon = @current_account.salons.find(params[:id])
  end

  # GET /salons/new
  def new
    @salon = Salon.new
  end

  # GET /salons/1/edit
  def edit
    @salon = @current_account.salons.find(params[:id])
  end

  # POST /salons
  def create
    @salon = Salon.new(params[:salon])
    @salon.account_id = @current_account.id

    respond_to do |format|
      if @salon.save
        format.html {redirect_to(@salon, 
                       :notice => "Salon was successfully created")}

      else
        format.html {render :action => "new"}
      end
    end
  end
end
