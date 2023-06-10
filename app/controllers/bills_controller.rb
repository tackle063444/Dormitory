class BillsController < ApplicationController
  before_action :set_bill, only: %i[ show edit update destroy  ]
  
  def index
    @bills = Bill.includes(room: :hall).all
    @bill = Bill.new(form_select: params[:form_select])
    @halls = Hall.all
    @selected_hall_id = params[:hall_id]
    @selected_form_select = params[:form_select]
    @selected_bill_date = params[:bill_date]
    
    if params[:form_select].present?
      @bills = @bills.where(form_select: params[:form_select])
    end
    
  end
  

  def new
    @bill = Bill.new(form_select: params[:form_select])
    @bill.bill_date = Date.today
  end
  
  def clone
    bill = Bill.find(params[:id])
    cloned_bill = bill.dup
    cloned_bill.form_select = 'form2' 
    cloned_bill.save!
    bill.head_lists.each do |head_list|
      new_head_list = head_list.dup
      new_head_list.bill_id = cloned_bill.id
      new_head_list.save
    end
    redirect_to bills_path, notice: 'Bill cloned successfully.'
  end
  
  
    def export_ex
      workbook = Axlsx::Package.new

      halls = Hall.all

      halls.each do |hall|
        bills = Bill.joins(room: :hall).where("halls.id = ?", hall.id).order("rooms.room_num")
    
      workbook.workbook.add_worksheet(name: hall.hall_name) do |sheet|

        bill_lists = BillList.all.order(:list_typeName)
        bill_list_typenames = bill_lists.pluck(:list_typeName)
    
        header_style = sheet.styles.add_style(bg_color: '74B678')
        listrow_style = sheet.styles.add_style(bg_color: 'D0D0D0')
        expenes_style = sheet.styles.add_style(bg_color: 'E85061')
        sum_style = sheet.styles.add_style(bg_color: '30CFB4')

        head_sheet = ['ห้อง', 'ประเภทใบเสร็จ'] + bill_list_typenames + ['หน่วยเดิม','หน่วยใหม่','ใช้ไป','ราคาต่อหน่วย','ยอดรวมใบเสร็จทั้งหมด','', 'หมายเหตุ']
        sheet.add_row head_sheet, style: header_style

        bill_names = Set.new
    
        #bills = Bill.joins(room: :hall).where("halls.id = ?", params[:form][:hall_id]).order("rooms.room_num")

        bills_by_form_select = bills.group_by(&:form_select_text)
        
        bills_by_form_select.each do |form_select_text, bills_for_form|
      
          sheet.add_row [form_select_text, *[""] * (bill_list_typenames.size + 4), "", "", "",""], style: listrow_style
    
          bills_for_form.each do |bill|
            
            room_num = bill.room.room_num
            amount = bill.head_lists.sum(:amount)
            head_total = bill.head_lists.sum(:head_total)
            bill_total = bill.bill_total
            old_unit = bill.head_lists.sum(:old_unit)
            new_unit = bill.head_lists.sum(:new_unit)
            e_price = bill.head_lists.sum(:e_price)
            unit_price = bill.head_lists.find_by(bill_list_id: 1)&.bill_list&.unit_price || 0

            row_data = [room_num, form_select_text]
            bill_lists.each do |bill_list|
              head_list = bill.head_lists.find_by(bill_list_id: bill_list.id)
              row_data << (head_list ? "#{head_list.head_total}" : "0")
            end
    
            row_data << old_unit
            row_data << new_unit 
            row_data << e_price
            row_data << unit_price
            row_data << bill_total
            row_data << ("#{Baht.words(bill_total)}")
            row_data << bill.bill_remark
            sheet.add_row row_data
            bill_names.add(form_select_text)

          end

        end
    
        amount_sum = bills.sum { |bill| bill.head_lists.sum(:e_price) }
        bill_total_sum = bills.reject { |bill| bill.form_select_text == 'ใบแจ้งค่าบริการห้องพัก' }.sum(&:bill_total)
    
        column_sums = bill_lists.map do |bill_list|
          bills.reject { |bill| bill.form_select_text == 'ใบแจ้งค่าบริการห้องพัก' }.sum { |bill| bill.head_lists.find_by(bill_list_id: bill_list.id)&.head_total || 0 }
        end
        
        other_income_row = ["รายรับอื่นๆ", "", *[""] * (bill_list_typenames.size + 4), "", "", ""]
        
        row_data = ["", "", *column_sums, "0", "0", amount_sum, "0", bill_total_sum, "", ""]
        sheet.add_row row_data, style: header_style
        sheet.add_row other_income_row, style: listrow_style

        @more_lists = MoreList.all

        bill_total_sum_revenue = 0
        bill_total_sum_expenses = 0

        @more_lists.each do |more_list|
          if more_list.form_select_text == "รายรับ"
            name_morelist = more_list.name_morelist
            unit_morelist = more_list.unit_morelist
            sheet.add_row [name_morelist, "", *[""] * (bill_list_typenames.size + 4), unit_morelist, "", ""]
            
            if unit_morelist.present?
              bill_total_sum_revenue += unit_morelist.to_i
            end
          end
        end
        bill_total_sum_morelist = bill_total_sum_revenue + bill_total_sum

        sheet.add_row ["", "", *[""] * (bill_list_typenames.size + 3),"รวม", bill_total_sum_revenue, "", ""]
        sheet.add_row ["", "", *[""] * (bill_list_typenames.size + 3),"รวมรายรับ", bill_total_sum_morelist, "", ""], style: header_style
        other_expenses_row = ["รายจ่ายอื่นๆ", "", *[""] * (bill_list_typenames.size + 4), "", "", ""]
        sheet.add_row other_expenses_row, style: expenes_style

        other_expenses_row = ["วันที่", "รายการ","ราคา","หมายเหตุ"]
        sheet.add_row other_expenses_row

        @more_lists.each do |more_list|
          if more_list.form_select_text == "รายจ่าย"
            name_morelist = more_list.name_morelist
            unit_morelist = more_list.unit_morelist
            sheet.add_row ["", name_morelist, unit_morelist,""]
            
            if unit_morelist.present?
              bill_total_sum_expenses += unit_morelist.to_i
            end
          end
        end
        sheet.add_row ["", "รวมรายจ่าย", bill_total_sum_expenses, ""]

        sheet.add_row ["สรุป", "", ], style: sum_style
        sheet.add_row ["รายรับ", bill_total_sum_morelist]
        sheet.add_row ["รายจ่าย", bill_total_sum_expenses]

        alltotal = bill_total_sum_morelist - bill_total_sum_expenses
        
        sheet.add_row ["คงเหลือ", alltotal]

    end
  end
      send_data workbook.to_stream.read, filename: 'Dormitory.xlsx', type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
    end
  

  def download
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
    #pdf.image "#{Rails.root}/app/assets/images/#{@bill.hall.hall_logo}", position: :left, fit: [70, 70]
    up_images = File.open(Rails.root + "public/#{@bill.room.hall.hall_logo.url}", 'rb')
    pdf.image up_images, fit: [70, 70]


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
        pdf.text "วันที่ #{Time.now.strftime('%Y-%m-%d')}"
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
            [i + 1, "#{two_r_text} #{bh.bill_list.list_typeName}", bh.e_price, bh.head_total.to_s]
        else
            [i + 1, "#{two_r_text} #{bh.bill_list.list_typeName}", bh.amount, bh.head_total.to_s]
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
    #pdf.image("/public/uploads/hall/hall_logo/11/d18c27c3-b822-42ab-b5f3-43404009e109.jpg", position: :left, fit: [70, 70])
    up_images = File.open(Rails.root + "public/#{@bill.room.hall.hall_logo.url}", 'rb')
    pdf.image up_images, fit: [70, 70]
    

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
        pdf.text "วันที่ #{@bill.bill_date.strftime('%Y-%m-%d')}"
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
            [i + 1, "#{two_r_text} #{bh.bill_list.list_typeName}", bh.e_price, bh.head_total.to_s]
        else
            [i + 1, "#{two_r_text} #{bh.bill_list.list_typeName}", bh.amount, bh.head_total.to_s]
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
    respond_to do |format|
      begin
        @bill.destroy
        format.html { redirect_to bills_url, notice: "Bill was successfully destroyed." }
        format.json { head :no_content }
      rescue
        format.html { redirect_to bills_url, notice: "Failed to delete Bill please check relatioship." }
        format.json { head :no_content }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bill
      if params[:id] != 'export_exel'
        @bill = Bill.find(params[:id])
      end
    end

    # Only allow a list of trusted parameters through.
    def bill_params
      params.require(:bill).permit(
        :bill_date, :bill_no, :bill_total, :bill_remark, :rent_id, :form_select, :room_id,
        head_lists_attributes: [:id, :bill_list_id, :list_typeNmae, :unit_price, :two_r, :old_unit, :new_unit, :amount, :e_price, :head_total, :_destroy]
      )
    end
    
    
     
end
