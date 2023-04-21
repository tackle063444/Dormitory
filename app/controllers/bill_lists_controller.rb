class BillListsController < ApplicationController
  before_action :set_bill_list, only: %i[ show edit update destroy ]

  # GET /bill_lists or /bill_lists.json
  def index
    @bill_lists = BillList.all
  end


  # GET /bill_lists/new
  def new
    @bill_list = BillList.new
  end

  # GET /bill_lists/1/edit
  def edit
  end

  # POST /bill_lists or /bill_lists.json
  def create
    @bill_list = BillList.new(bill_list_params)

    respond_to do |format|
      if @bill_list.save
        format.html { redirect_to bill_lists_url(@bill_list), notice: "Bill list was successfully created." }
        format.json { render :index, status: :created, location: @bill_list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bill_lists/1 or /bill_lists/1.json
  def update
    respond_to do |format|
      if @bill_list.update(bill_list_params)
        format.html { redirect_to bill_lists_url(@bill_list), notice: "Bill list was successfully updated." }
        format.json { render :index, status: :ok, location: @bill_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bill_lists/1 or /bill_lists/1.json
  def destroy
    @bill_list.destroy

    respond_to do |format|
      format.html { redirect_to bill_lists_url, notice: "Bill list was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill_list
      @bill_list = BillList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bill_list_params
      params.require(:bill_list).permit(:list_typeName, :unit_price)
    end
end
