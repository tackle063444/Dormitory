class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy  ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.includes(:room).all
    @bill = Bill.new(form_select: params[:form_select])
  end

  def download
    bill = Bill.find(params[:id])
    if @bill.present?
      pdf = Prawn::Document.new
      normal_thai_font = "#{Rails.root.to_s}/app/assets/fonts/THSarabunNew/THSarabunNew.ttf"
      pdf.font_families["THSarabun"] = { :normal => { :file => normal_thai_font } }
      pdf.font "THSarabun"
      pdf.text "Bill Number: #{@bill.bill_no}"
      pdf.text "Room Number: #{@bill.room&.room_num}"
      pdf.text "Bill Type: #{@bill.form_select_text}"
      send_data pdf.render,
                filename: "#{@bill.bill_no}.pdf",
                type: 'application/pdf'
    else
      render plain: "error"
    end
  end
   
  
  
  def preview
    @bill = Bill.find(params[:id])
    if @bill.present?
      pdf = Prawn::Document.new
      normal_thai_font = "#{Rails.root.to_s}/app/assets/fonts/THSarabunNew/THSarabunNew.ttf"
      pdf.font_families["THSarabun"] = { :normal => { :file => normal_thai_font } }
      pdf.font "THSarabun"
      pdf.image "#{Rails.root}/app/assets/images/logo001.png", position: :left, fit: [70, 70]
      pdf.bounding_box([pdf.bounds.right - 400, pdf.bounds.top - 0], width: 400, height: 80) do
        pdf.text "หมายเลขห้อง  #{@bill.room&.room_num}", align: :right
        pdf.text "#{@bill.form_select_text}", align: :right
        pdf.text "#{@bill.room.hall.hall_name} #{@bill.room.hall.hall_address}", align: :right
        pdf.text "โทร #{@bill.room.hall.hall_tel}", align: :right
        
      end
      firstName_users = ""
      @bill.room.rents.each do |rent|
        firstName_users += rent.user.user_fname + " " + rent.user.user_lname + ", "
      end

      tel_users = ""
      @bill.room.rents.each do |rent|
        tel_users += rent.user.user_tel.to_s + ", "
      end

      pdf.bounding_box([pdf.bounds.left - 0, pdf.bounds.top - 80], width: 335, height: 70) do
        pdf.text "ชื่อผู้เช่า : #{firstName_users}"
        pdf.text "ที่อยู่ : ห้อง #{@bill.room.room_num}"
        pdf.text "โทร #{tel_users}"
        pdf.stroke_bounds
      end

      pdf.bounding_box([pdf.bounds.right - 190, pdf.bounds.top - 80], width: 190, height: 70) do
        pdf.text "วันที่ #{@bill.created_at}"
        pdf.text "เลขที่ #{@bill.bill_no}"
        pdf.stroke_bounds
      end

      # listTypeName = ""
      # @bill.head_lists.bill_lists.each do |head_list|
      #   listTypeName += head_list.bill_list.list_typeName + "\n"
      # end

      # amountInList = ""
      # @bill.head_lists.each do |head_list|
      #   amountInList += head_list.amount + "\n"
      # end

      # headTotal = ""
      # @bill.head_lists.each do |head_list|
      #   headTotal += head_list.head_total + "\n"
      # end

      pdf.table([["ลำดับ", "รายการ", "จำนวน", "จำนวนเงิน"]] +
      @bill.head_list.each_with_index do |bh, i|
        [i, bh.bill_list.list_typeName, "", "", ""]
      end,
      width: pdf.bounds.width,
      column_widths: { 0 => 50, 1 => 300, 2 => 70, 3 => 120 },
      header: true,
      cell_style: { border_width: 1, padding: [5, 10] },
      header_style: { background_color: 'DDDDDD', border_width: 1 }
)
   
      
      send_data pdf.render,
                filename: "preview.pdf",
                type: 'application/pdf',
                disposition: 'inline'
    else
      render plain: "error"
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
    @bill = Bill.new(form_select: params[:form_select])
 
  end

    # GET /bills/1/edit
  def edit
    total_users = Room.where(room_num: request.params[:room_num]).joins(:rents).distinct.count('rents.user_id')
  end

  
  # POST /bills or /bills.json
  def create
    selected_form = params[:bill]["form_select"]
    bill_params_with_room_id = bill_params.merge(room_id: params[:bill][:room_id]).merge(form_select: selected_form)
    @bill = Bill.new(bill_params_with_room_id)
    @bill.get_bill_no 

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
      params.require(:bill).permit(
        :bill_date, :bill_no, :bill_total, :bill_remark, :rent_id, :form_select, :room_id,
        head_lists_attributes: [:id, :bill_lists_id, :list_typeNmae, :unit_price, :old_unit, :new_unit, :amount, :e_price, :head_total, :_destroy]
      )
    end
    
    
     
end
