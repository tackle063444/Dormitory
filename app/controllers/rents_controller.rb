class RentsController < ApplicationController
  before_action :set_rent, only: %i[ show edit update destroy ]

  # GET /rents or /rents.json
  def index
    if params[:room_id].present?
      @rent = Rent.where(room_id: params[:room_id])
    else
      @rent = Rent.all
    end
  end

  # GET /rents/1 or /rents/1.json
  def show
  end
  
  def renters
    room_id = params[:room_id]
    rents = Rent.where(room_id: room_id).pluck(:user_id).uniq
    users = User.where(id: rents)
    render json: users
  end
  

  def get_rent_user_info
    room_id = params[:room_id]
    # ดึงข้อมูลผู้ใช้งานที่เช่าห้องดังกล่าว
    @users = User.joins(rents: :room).where(rooms: { id: room_id }).select('users.id, users.user_fname, users.user_lname, rents.id AS rent_id')
    # ส่งกลับเป็น JSON response
    render json: @users
  end
  # GET /rents/new
  def new
    @rent = Rent.new
  end

  # GET /rents/1/edit
  def edit
  end

  # POST /rents or /rents.json
  def create
    @rent = Rent.new(rent_params)
  
    respond_to do |format|
      if @rent.save
        #RentLog.create(action: "create", rent_id: @rent.id, user_id: @rent.user_id, user_fname: @rent.user.user_fname, user_lname: @rent.user.user_lname, room_num: @rent.room.room_num, rent_start: @rent.rent_start, rent_end: @rent.rent_end)
        format.html { redirect_to rents_url(@rent), notice: "Rent was successfully created." }
        format.json { render :show, status: :created, location: @rent }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rent.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PATCH/PUT /rents/1 or /rents/1.json
  def update
    respond_to do |format|
      if @rent.update(rent_params)
        #RentLog.create(action: "update", rent_id: @rent.id, user_id: @rent.user_id, user_fname: @rent.user.user_fname, user_lname: @rent.user.user_lname, room_num: @rent.room.room_num, rent_start: @rent.rent_start, rent_end: @rent.rent_end)
        format.html { redirect_to rents_url(@rent), notice: "Rent was successfully updated." }
        format.json { render :show, status: :ok, location: @rent }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rents/1 or /rents/1.json
  def destroy
    @rent.destroy
    respond_to do |format|
      format.html { redirect_to rents_url, notice: "Rent was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rent
      @rent = Rent.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rent_params
      params.require(:rent).permit(:room_id, :user_id, :rent_start, :rent_end)
    end
end
