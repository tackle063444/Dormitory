class RentLog < ApplicationRecord
    belongs_to :rent
    belongs_to :user
end
