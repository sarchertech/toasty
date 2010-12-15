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

  # PUT /salons/1
  def update
    @salon = @current_account.salons.find(params[:id])

    respond_to do |format|
      if @salon.update_attributes(params[:salon])
        format.html {redirect_to(@salon,
                       :notice => "Salon was successfully updated")}
      else
        format.html {render :action => "edit"}
      end
    end
  end

  # DELETE /salons/1
  def destroy
    @salon = @current_account.salons.find(params[:id])
    @salon.destroy

    respond_to do |format|
      format.html {redirect_to(salons_url)}
    end
  end
end
