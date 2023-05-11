class HeadList < ApplicationRecord
    belongs_to :bill
    has_many :bill_lists
end
