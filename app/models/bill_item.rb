class BillItem < ApplicationRecord
    belongs_to :bill
    belongs_to :bill_list
  end