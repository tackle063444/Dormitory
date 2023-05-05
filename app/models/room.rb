class Room < ApplicationRecord
  belongs_to :hall
  has_many :rents, foreign_key: :room_id
  has_many :bills

  enum room_status: ['ว่าง', 'ไม่ว่าง', 'จอง', 'ยกเลิก']
end
