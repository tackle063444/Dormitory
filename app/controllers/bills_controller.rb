class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy  ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
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
    @bill.form_select = params[:form_select]
  end

    # GET /bills/1/edit
    def edit

    end


  # POST /bills or /bills.json
  def create
    if Bill.column_names.include?("rent_id") && Rent.exists?(id: params[:bill][:rent_id])
      @bill = Bill.new(bill_params)
      respond_to do |format|
        if @bill.save
          format.html { redirect_to bills_url(@bill), notice: "Bill was successfully created." }
          format.json { render :index, status: :created, location: @bill }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @bill.errors, status: :unprocessable_entity }
        end
      end
    else
      flash[:error] = "The rent_id does not exist in the database"
      redirect_to new_bill_path
    end
  end
  
  
  

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
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
      params.require(:bill).permit(:bill_list_id, :bill_date, :bill_no, :bill_total, :bill_remark, :rent_id)
    end
     
end
