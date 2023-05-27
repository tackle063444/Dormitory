class RentLogsController < ApplicationController
  before_action :set_rent_log, only: %i[ show edit update destroy ]

  # GET /rent_logs or /rent_logs.json
  def index
    @rent_logs = RentLog.all
  end

  # GET /rent_logs/1 or /rent_logs/1.json
  def show
  end

  # GET /rent_logs/new
  def new
    @rent_log = RentLog.new
  end

  def user_history
    # ดึงข้อมูล logs จากฐานข้อมูล
    @rent_logs = RentLog.order(created_at: :desc)
  
    # กลับลำดับข้อมูล
    @rent_logs = @rent_logs.reverse
  end

  # GET /rent_logs/1/edit
  def edit
  end

  # POST /rent_logs or /rent_logs.json
  def create
    @rent_log = RentLog.new(rent_log_params)

    respond_to do |format|
      if @rent_log.save
        format.html { redirect_to rent_log_url(@rent_log), notice: "Rent log was successfully created." }
        format.json { render :show, status: :created, location: @rent_log }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rent_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rent_logs/1 or /rent_logs/1.json
  def update
    respond_to do |format|
      if @rent_log.update(rent_log_params)
        format.html { redirect_to rent_log_url(@rent_log), notice: "Rent log was successfully updated." }
        format.json { render :show, status: :ok, location: @rent_log }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rent_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rent_logs/1 or /rent_logs/1.json
  def destroy
    @rent_log.destroy

    respond_to do |format|
      format.html { redirect_to rent_logs_url, notice: "Rent log was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rent_log
      @rent_log = RentLog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rent_log_params
      params.fetch(:rent_log, {})
    end
end
