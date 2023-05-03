class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy  ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.includes(:room).all
    @bill = Bill.new(form_select: params[:form_select])
  end
  

  def generate_bill
    @bill = Bill.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = Prawn::Document.new
        pdf.text "Hello, World!"
        send_data pdf.render, filename: "example.pdf", type: "application/pdf", disposition: "inline"
      end
    end
  end
  

  # GET /bills/1 or /bills/1.json
  def show
    @bill = Bill.find(params[:id])
    
    respond_to do |format|
      format.html
      format.pdf do
        send_data PdfGenerator.generate(@bill), filename: "bill_#{params[:id]}.pdf", type: 'application/pdf', disposition: 'attachment'
      end
    end
  end

  # GET /bills/new
  def new
    @bill = Bill.new
    @bill = Bill.new(form_select: params[:form_select])
  end

    # GET /bills/1/edit
  def edit

  end

  
  # POST /bills or /bills.json
  def create
    selected_form = params[:bill]["form-select"]
    bill_params_with_room_id = bill_params.merge(room_id: params[:bill][:room_id]).merge(form_select: selected_form)
    @bill = Bill.new(bill_params_with_room_id)
    @bill.get_bill_no # เรียกใช้ method get_bill_no เพื่อกำหนดค่า bill_no
    respond_to do |format|
      if @bill.save
        redirect_to bills_url(@bill), notice: "Bill was successfully created." and return
      else
        flash[:error] = "Error: Bill creation failed"
        redirect_to new_bill_path and return
      end
    end
  end
  
  

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      puts "bill_params",bill_params
      #byebug
      if @bill.update(bill_params)
        format.html { redirect_to bills_url(@bill), notice: "Bill was successfully updated." }
        format.json { render :index, status: :ok, location: @bill }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1 or /bills/1.json
  def destroy
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to bills_url, notice: "Bill was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      @bill = Bill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bill_params
      params.require(:bill).permit(:bill_list_id, :bill_date, :bill_no, :bill_total, :bill_remark, :rent_id,:form_select, :room_id).tap do |whitelisted|
        #unless Rent.exists?(id: whitelisted[:rent_id])
        #  flash[:error] = "ไม่พบการเช่าห้องนี้"

        #end
      end
    end
    
     
end
