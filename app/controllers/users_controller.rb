class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
    #if params[:room_id]
    #  @users = User.joins(rents: :room).where(rooms: { id: params[:room_id] })
    #else
    #  @users = User.all
    #end
  end

  def set_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      # handle the error, e.g. redirect to an error page
    end
  end 
  
  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        UserLog.create(action: "create", user_id: @user.id, user_fname: @user.user_fname, user_lname: @user.user_lname, user_address: @user.user_address, user_tel: @user.user_tel)
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        UserLog.create(action: "update", user_id: @user.id, user_fname: @user.user_fname, user_lname: @user.user_lname, user_address: @user.user_address, user_tel: @user.user_tel)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    
    UserLog.create(action: "delete", user_id: @user.id, user_fname: @user.user_fname, user_lname: @user.user_lname, user_address: @user.user_address, user_tel: @user.user_tel)
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:user_fname, :user_lname, :user_address, :user_tel)
    end
end
