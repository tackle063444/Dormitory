class Room < ApplicationRecord
  belongs_to :hall
  belongs_to :user

end
