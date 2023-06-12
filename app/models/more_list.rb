class MoreList < ApplicationRecord
  belongs_to :hall
  
    def form_select_text
        case type_morelist
        when 'form1' 
          "รายรับ"
        when 'form2' 
          "รายจ่าย"
        end
    end

end
