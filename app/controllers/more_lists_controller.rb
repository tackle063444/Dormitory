class MoreListsController < ApplicationController
  before_action :set_more_list, only: %i[ show edit update destroy ]

  # GET /more_lists or /more_lists.json
  def index
    @more_lists = MoreList.all
  end

  # GET /more_lists/1 or /more_lists/1.json
  def show
  end

  # GET /more_lists/new
  def new
    @more_list = MoreList.new
  end

  # GET /more_lists/1/edit
  def edit
  end

  # POST /more_lists or /more_lists.json
  def create
    @more_list = MoreList.new(more_list_params)

    respond_to do |format|
      if @more_list.save
        format.html { redirect_to more_list_url(@more_list), notice: "More list was successfully created." }
        format.json { render :show, status: :created, location: @more_list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @more_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /more_lists/1 or /more_lists/1.json
  def update
    respond_to do |format|
      if @more_list.update(more_list_params)
        format.html { redirect_to more_list_url(@more_list), notice: "More list was successfully updated." }
        format.json { render :show, status: :ok, location: @more_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @more_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /more_lists/1 or /more_lists/1.json
  def destroy
    @more_list.destroy

    respond_to do |format|
      format.html { redirect_to more_lists_url, notice: "More list was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_more_list
      @more_list = MoreList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def more_list_params
      params.require(:more_list).permit(:type_morelist, :name_morelist, :unit_morelist)
    end
end
