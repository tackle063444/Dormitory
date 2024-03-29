class HallsController < ApplicationController
  before_action :set_hall, only: %i[ show edit update destroy ]

  # GET /halls or /halls.json
  def index
    @halls = Hall.all
  end

  # GET /halls/1 or /halls/1.json
  def show
  end

  # GET /halls/new
  def new
    @hall = Hall.new
  end

  # GET /halls/1/edit
  def edit
  end

  # POST /halls or /halls.json
  def create
    @hall = Hall.new(hall_params)
    @hall.hall_logo = params[:hall][:hall_logo]

    respond_to do |format|
      if @hall.save
        format.html { redirect_to halls_path, notice: "Hall was successfully created." }
        format.json { render :index, status: :created, location: @hall }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @hall.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @hall.update(hall_params)
        format.html { redirect_to halls_url(@hall), notice: "Hall was successfully updated." }
        format.json { render :index, status: :ok, location: @hall }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @hall.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    respond_to do |format|
      begin
        @hall.destroy
        format.html { redirect_to halls_url, notice: "Hall was successfully destroyed." }
        format.json { head :no_content }
      rescue
        format.html { redirect_to halls_url, notice: "Failed to delete Hall please check relatioship." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hall
      @hall = Hall.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
  def hall_params
  params.require(:hall).permit(:hall_name, :hall_address, :hall_tel, :codename_hall, :hall_logo)
  end

 
end
