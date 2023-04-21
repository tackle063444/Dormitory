class Bill < ApplicationRecord
  belongs_to :bill_list
  belongs_to :rent
end
