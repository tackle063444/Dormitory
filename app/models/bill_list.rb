class BillList < ApplicationRecord
    belongs_to :bill, optional: true

    def bill_list_price
        "#{list_typeName} #{unit_price}"
      end
      
end
