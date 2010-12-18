class BedsController < ApplicationController
  # GET /salons/1/beds
  def index
    @beds = @current_salon.beds 
  end

  # GET /salons/1/beds/1
  def show
    @bed = @current_salon.beds.find(params[:id])
  end

  # GET /salons/1/beds/new
  def new
    @bed = Bed.new
  end

  # GET /salons/1/beds/1/edit
  def edit
    @bed = @current_salon.beds.find(params[:id])
  end

  # POST /salons/1/beds
  def create
    @bed = Bed.new(params[:bed])
    @bed.salon_id = @current_salon.id

    respond_to do |format|
      if @bed.save
        format.html {redirect_to([@current_salon, @bed],
                       :notice => "Bed was successfully created")}
      else
        format.html {render :action => "new"}
      end
    end
  end

  # PUT /salons/1/beds/1
  def update
    @bed = @current_salon.beds.find(params[:id])

    respond_to do |format|
      if @bed.update_attributes(params[:bed])
        format.html {redirect_to([@current_salon, @bed],
                       :notice => "Bed was successfully updated")}
      else
        format.html {render :action => "edit"}
      end
    end
  end

  #DELETE /salons/1/beds/1
  def destroy
    @bed = @current_salon.beds.find(params[:id])
    @bed.destroy

    respond_to do |format|
      format.html {redirect_to(salon_beds_url)}
    end
  end
end
