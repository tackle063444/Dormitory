class HeadListsController < ApplicationController
  before_action :set_head_list, only: %i[ show edit update destroy ]

  # GET /head_lists or /head_lists.json
  def index
    @head_lists = HeadList.all
  end

  # GET /head_lists/1 or /head_lists/1.json
  def show
  end

  # GET /head_lists/new
  def new
    @head_list = HeadList.new
  end

  # GET /head_lists/1/edit
  def edit
  end

  # POST /head_lists or /head_lists.json
  def create
    @head_list = HeadList.new(head_list_params)

    respond_to do |format|
      if @head_list.save
        format.html { redirect_to head_list_url(@head_list), notice: "Head list was successfully created." }
        format.json { render :show, status: :created, location: @head_list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @head_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /head_lists/1 or /head_lists/1.json
  def update
    respond_to do |format|
      if @head_list.update(head_list_params)
        format.html { redirect_to head_list_url(@head_list), notice: "Head list was successfully updated." }
        format.json { render :show, status: :ok, location: @head_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @head_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /head_lists/1 or /head_lists/1.json
  def destroy
    @head_list.destroy

    respond_to do |format|
      format.html { redirect_to head_lists_url, notice: "Head list was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_head_list
      @head_list = HeadList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def head_list_params
      params.fetch(:head_list, {})
    end
end
