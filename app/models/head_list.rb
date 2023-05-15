class HeadList < ApplicationRecord
    belongs_to :bill
    belongs_to :bill_list

    def form_select_text
        case two_r
        when 'form1'
        "หัก"
        when 'form2'
        "คืน"
        end    
    end
end
