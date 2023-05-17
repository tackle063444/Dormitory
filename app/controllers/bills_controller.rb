class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy  ]

  # GET /bills or /bills.json
  def index
    @bills = Bill.includes(:room).all
    @bill = Bill.new(form_select: params[:form_select])
  end

  def download
    @bill = Bill.find(params[:id])
    if @bill.present?

      pdf = Prawn::Document.new
      normal_thai_font = "#{Rails.root.to_s}/app/assets/fonts/THSarabunNew/THSarabunNew.ttf"
      normal_thai_font = "#{Rails.root.to_s}/app/assets/fonts/THSarabunNew/THSarabunNew Bold.ttf"
      pdf.font_families["THSarabun"] = { :normal => { :file => normal_thai_font } }
      pdf.font "THSarabun", size: 15
      pdf.image "#{Rails.root}/app/assets/images/logo001.png", position: :left, fit: [70, 70]
     
      pdf.bounding_box([pdf.bounds.right - 400, pdf.bounds.top - 0], width: 400, height: 80) do
        pdf.text "<color rgb='0000FF'>หมายเลขห้อง  #{@bill.room&.room_num}</color>", align: :right, inline_format: true
        pdf.text "<font size='20'>#{@bill.form_select_text}</font>", align: :right, inline_format: true
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

      address_users = ""
      @bill.room.rents.each do |rent|
        address_users += rent.user.user_address.to_s + ", "
      end

      if @bill.form_select == 'form1' || @bill.form_select == 'form2' || @bill.form_select == 'form4'
      pdf.bounding_box([pdf.bounds.left - 0, pdf.bounds.top - 80], width: 335, height: 70) do
        pdf.text "ชื่อผู้เช่า : #{firstName_users}"
        pdf.text "ที่อยู่ : ห้อง #{@bill.room.room_num}"
        pdf.text "โทร #{tel_users}"
        pdf.stroke_bounds

      end
    end

    if @bill.form_select == 'form3' 
      pdf.bounding_box([pdf.bounds.left - 0, pdf.bounds.top - 80], width: 335, height: 70) do
        pdf.text "ชื่อผู้เช่า : #{firstName_users}"
        pdf.text "ที่อยู่ : #{address_users}"
        pdf.text "โทร #{tel_users}"
        pdf.stroke_bounds
      end
    end

      
      pdf.bounding_box([pdf.bounds.right - 190, pdf.bounds.top - 80], width: 190, height: 70) do
        pdf.text "วันที่ #{thai_date}"
        pdf.text "เลขที่ #{@bill.bill_no}"
        pdf.stroke_bounds
      end

      require 'prawn'
      require 'prawn/table'
      require 'baht'
      require 'date'
      
      thai_date = @bill.created_at.strftime("%d/%m/%Y")

      data = [["ลำดับ", "รายการ", "จำนวน", "จำนวนเงิน"]] +
      @bill.head_lists.each_with_index.map do |bh, i|
        if bh.bill_list_id == 1 || bh.bill_list.list_typeName == 'ค่าไฟ'
          [i + 1, bh.bill_list.list_typeName, bh.e_price, bh.head_total]
        else
          [i + 1, bh.bill_list.list_typeName, bh.amount, bh.head_total]
        end
      end +
      if @bill.form_select == 'form1'
        [
          [{:content => "(#{Baht.words(@bill.bill_total)})", :colspan => 2}, 
           {:content => "รวมจำนวนเงินทั้งสิ้น"}, 
           "#{@bill.bill_total}"],
          [{:content => "หมายเหตุ : #{@bill.bill_remark}
          ช่องทางการชำระเงิน : บัญชีธนาคารกสิกรไทย ชื่อบัญชีจุฑามาศ ปั้นเทียน เลขที่บัญชี 067890-565-8", :colspan => 4, :border_width => 0}]
        ]
      else
        [
          [{:content => "(#{Baht.words(@bill.bill_total)})", :colspan => 2}, 
           {:content => "รวมจำนวนเงินทั้งสิ้น"}, 
           "#{@bill.bill_total}"],
          [{:content => "หมายเหตุ : #{@bill.bill_remark}", :colspan => 4, :border_width => 0}]
        ]
      end
      
      
      pdf.bounding_box([pdf.bounds.left - 0, pdf.bounds.top - 180], width: 540, height: 800) do
        pdf.table(data,
           width: pdf.bounds.width,
           column_widths: { 0 => 50, 1 => 300, 2 => 110, 3 => 80 },
           header: true,
           cell_style: { border_width: 1, padding: [5, 10], align: :left  },
          )
      end
    
      if @bill.form_select == 'form1'
      pdf.bounding_box([pdf.bounds.left - -380, pdf.bounds.top - 670], width: 190, height: 100) do
        pdf.image("#{Rails.root}/app/assets/images/qrcode.png", position: :right, fit: [80, 80])
      end
    end
     
    if @bill.form_select == 'form2' || @bill.form_select == 'form3'
      pdf.bounding_box([pdf.bounds.left - -240, pdf.bounds.top - 550], width: 300, height: 300) do
        pdf.image("#{Rails.root}/app/assets/images/li.png", position: :right, fit: [120, 120])
      end
    end

    if @bill.form_select == 'form2' || @bill.form_select == 'form3'
      pdf.bounding_box([pdf.bounds.left - 0, pdf.bounds.top - 680], width: 540, height: 70) do
        pdf.text "ข้อมูลการชำระเงิน"
        pdf.text " :::  โอนเงินเข้าธนาคารกสิกรไทย ชื่อบัญชีจุฑามาศ ปั้นเทียน บัญชีเงินฝากออมทรัพย์ เลขที่บัญชี 067890-565-8"

      end
    end
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
    bold_thai_font = "#{Rails.root.to_s}/app/assets/fonts/THSarabunNew/THSarabunNew Bold.ttf"
    pdf.font_families.update(
      "THSarabun" => {
        normal: normal_thai_font,
        bold: bold_thai_font
      }
    )
    pdf.font('THSarabun', size: 15)

      pdf.bounding_box([pdf.bounds.right - 400, pdf.bounds.top - 0], width: 400, height: 80) do
        pdf.text "<color rgb='0000FF'>หมายเลขห้อง  #{@bill.room&.room_num}</color>", align: :right, inline_format: true
        pdf.text "<font size='20'>#{@bill.form_select_text}</font>", align: :right, inline_format: true
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

      address_users = ""
      @bill.room.rents.each do |rent|
        address_users += rent.user.user_address.to_s + ", "
      end

      if @bill.form_select == 'form1' || @bill.form_select == 'form2' || @bill.form_select == 'form4'
      pdf.bounding_box([pdf.bounds.left - 0, pdf.bounds.top - 80], width: 335, height: 70) do
        pdf.text "ชื่อผู้เช่า : #{firstName_users}"
        pdf.text "ที่อยู่ : ห้อง #{@bill.room.room_num}"
        pdf.text "โทร #{tel_users}"
        pdf.stroke_bounds

      end
    end

    if @bill.form_select == 'form3' 
      pdf.bounding_box([pdf.bounds.left - 0, pdf.bounds.top - 80], width: 335, height: 70) do
        pdf.text "ชื่อผู้เช่า : #{firstName_users}"
        pdf.text "ที่อยู่ : #{address_users}"
        pdf.text "โทร #{tel_users}"
        pdf.stroke_bounds
      end
    end

      
      pdf.bounding_box([pdf.bounds.right - 190, pdf.bounds.top - 80], width: 190, height: 70) do
        pdf.text "วันที่ #{@bill.created_at}"
        pdf.text "เลขที่ #{@bill.bill_no}"
        pdf.stroke_bounds
      end

      require 'prawn'
      require 'prawn/table'
      require 'baht'


    data = [["ลำดับ", "รายการ", "จำนวน", "จำนวนเงิน"]] +
    if @bill.form_select == 'form4'
      @bill.head_lists.each_with_index.map do |bh, i|
        two_r_text = bh.form_select_text  
        if bh.bill_list_id == 1 || bh.bill_list.list_typeName == 'ค่าไฟ'
          if two_r_text == 'หัก'
            [i + 1, "#{two_r_text} #{bh.bill_list.list_typeName}", bh.e_price, -bh.head_total]
          else
            [i + 1, "#{two_r_text} #{bh.bill_list.list_typeName}", bh.e_price, bh.head_total]
          end
        else
          if two_r_text == 'หัก'
            [i + 1, "#{two_r_text} #{bh.bill_list.list_typeName}", bh.amount, -bh.head_total]
          else
            [i + 1, "#{two_r_text} #{bh.bill_list.list_typeName}", bh.amount, bh.head_total]
          end
        end
      end
    else
      @bill.head_lists.each_with_index.map do |bh, i|
        if bh.bill_list_id == 1 || bh.bill_list.list_typeName == 'ค่าไฟ'
          [i + 1, bh.bill_list.list_typeName, bh.e_price, bh.head_total]
        else
          [i + 1, bh.bill_list.list_typeName, bh.amount, bh.head_total]
        end
      end
    end +
      if @bill.form_select == 'form1'
        [
          [{:content => "(#{Baht.words(@bill.bill_total)})", :colspan => 2}, 
           {:content => "รวมจำนวนเงินทั้งสิ้น"}, 
           "#{@bill.bill_total}"],
          [{:content => "หมายเหตุ : #{@bill.bill_remark}
          ช่องทางการชำระเงิน : บัญชีธนาคารกสิกรไทย ชื่อบัญชีจุฑามาศ ปั้นเทียน เลขที่บัญชี 067890-565-8", :colspan => 4, :border_width => 0}]
        ]
      else
        [
          [{:content => "(#{Baht.words(@bill.bill_total)})", :colspan => 2}, 
           {:content => "รวมจำนวนเงินทั้งสิ้น"}, 
           "#{@bill.bill_total}"],
          [{:content => "หมายเหตุ : #{@bill.bill_remark}", :colspan => 4, :border_width => 0}]
        ]
      end
      
      
      pdf.bounding_box([pdf.bounds.left - 0, pdf.bounds.top - 180], width: 540, height: 800) do
        pdf.table(data,
           width: pdf.bounds.width,
           column_widths: { 0 => 50, 1 => 300, 2 => 110, 3 => 80 },
           header: true,
           cell_style: { border_width: 1, padding: [5, 10], align: :left  },
          )
      end
    
      if @bill.form_select == 'form1'
      pdf.bounding_box([pdf.bounds.left - -380, pdf.bounds.top - 670], width: 190, height: 100) do
        pdf.image("#{Rails.root}/app/assets/images/qrcode.png", position: :right, fit: [80, 80])
      end
    end
     
    if @bill.form_select == 'form2' || @bill.form_select == 'form3'
      pdf.bounding_box([pdf.bounds.left - -240, pdf.bounds.top - 550], width: 300, height: 300) do
        pdf.image("#{Rails.root}/app/assets/images/li.png", position: :right, fit: [120, 120])
      end
    end

    if @bill.form_select == 'form2' || @bill.form_select == 'form3'
      pdf.bounding_box([pdf.bounds.left - 0, pdf.bounds.top - 680], width: 540, height: 70) do
        pdf.text "ข้อมูลการชำระเงิน"
        pdf.text " :::  โอนเงินเข้าธนาคารกสิกรไทย ชื่อบัญชีจุฑามาศ ปั้นเทียน บัญชีเงินฝากออมทรัพย์ เลขที่บัญชี 067890-565-8"

      end
    end
      
      
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
        head_lists_attributes: [:id, :bill_list_id, :list_typeNmae, :unit_price, :two_r, :old_unit, :new_unit, :amount, :e_price, :head_total, :_destroy]
      )
    end
    
    
     
end
