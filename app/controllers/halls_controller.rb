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
  
    respond_to do |format|
      if @hall.save
        if params[:hall][:hall_logo].present?
          uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: params[:hall][:hall_logo].tempfile, filename: params[:hall][:hall_logo].original_filename)

          # แนบไฟล์ที่อัปโหลดเข้ามาให้กับ attribute `hall_logo`
          @hall.hall_logo.attach(io: uploaded_file, filename: uploaded_file.original_filename)
        end
        
        logger.debug("Hall #{@hall} was successfully created")
        format.html { redirect_to @hall, notice: "Hall was successfully created." }
        format.json { render :show, status: :created, location: @hall }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @hall.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @hall.update(hall_params)
        if params[:hall][:hall_logo].present?
          hall_logo = params[:hall][:hall_logo]
          @hall.hall_logo.attach(io: hall_logo.read, filename: hall_logo.original_filename)
        end
        
        logger.debug("Hall #{@hall} was successfully updated")
        format.html { redirect_to @hall, notice: "Hall was successfully updated." }
        format.json { render :show, status: :ok, location: @hall }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @hall.errors, status: :unprocessable_entity }
      end
    end
  end
  
  

  # DELETE /halls/1 or /halls/1.json
  def destroy
    @hall.destroy
    respond_to do |format|
      format.html { redirect_to halls_url, notice: "Hall was successfully destroyed." }
      format.json { head :no_content }
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
