class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy  ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.all
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
    @form = params[:form]
  end

    # GET /bills/1/edit
    def edit

    end
    
    def submit_bill_form
      # รับค่าจากฟอร์ม
      bill_params = params[:bill]
    
      # สร้าง object ของ Bill จากข้อมูลในฟอร์ม
      @bill = Bill.new(rent_id: bill_params[:rent_id],
                       bill_list_id: bill_params[:bill_list_id],
                       bill_date: bill_params[:bill_date],
                       bill_no: bill_params[:bill_no],
                       bill_total: bill_params[:bill_total],
                       bill_remark: bill_params[:bill_remark])
    
      # รับค่า form จาก params
      @form = params[:bill][:'form-select']
    
      respond_to do |format|
        if @bill.save
          format.json { render json: { success: true, message: 'บันทึกข้อมูลเรียบร้อย' } }
        else
          format.json { render json: { success: false, message: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล' } }
        end
      end
    end
    

  def bill_form_partial
    form = params[:form]
 
    @bill = Bill.new
  
    # แก้ไขตามลักษณะของ partial ของฟอร์มที่ต้องการ
    case form
    when 'form1'
      html = render_to_string(partial: 'form1')
    when 'form2'
      html = render_to_string(partial: 'form2')
    when 'form3'
      html = render_to_string(partial: 'form3')
    when 'form4'
      html = render_to_string(partial: 'form4')
    else
      html = ''
    end
  
    render json: { html: html }
  end
  
  
  # POST /bills or /bills.json
  def create
    @bill = Bill.new(bill_params)
  
    respond_to do |format|
      if @bill.save
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully created." }
        format.json { render :show, status: :created, location: @bill }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PATCH/PUT /bills/1 or /bills/1.json
  def update
    respond_to do |format|
      if @bill.update(bill_params)
        format.html { redirect_to bill_url(@bill), notice: "Bill was successfully updated." }
        format.json { render :show, status: :ok, location: @bill }
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
      params.require(:bill).permit(:rent_id, :bill_list_id, :bill_date, :bill_no, :bill_total, :bill_remark)
    end
end
