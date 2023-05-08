class BillList < ApplicationRecord
    belongs_to :bill, optional: true
end
