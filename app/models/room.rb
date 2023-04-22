class Room < ApplicationRecord
  belongs_to :hall
  has_many :rents, foreign_key: :room_id

end
