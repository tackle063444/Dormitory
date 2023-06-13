class BillList < ApplicationRecord
    belongs_to :bill, optional: true

    def bill_list_price
        "#{list_typeName} #{unit_price}"
      end

        
  def form_select_text
    case name_unit 
    when 'form1' 
      "ท่าน"
    when 'form2' 
      "ห้อง"
    when 'form3' 
      "หน่วย"
    when 'form4' 
     "เครื่อง"
    when 'form5' 
      "บาท"
    end 
  end

end
