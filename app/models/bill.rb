class Bill < ApplicationRecord
  belongs_to :bill_list
  belongs_to :rent
  belongs_to :hall

  attr_accessor :bill_form

end
