class Room < ApplicationRecord
  belongs_to :hall
  has_many :rents, foreign_key: :room_id
  has_many :bills


  def self.check_room_user_relation

    room_ids = Rent.joins(:room).group(:room_id).count.select {|k,v| v == 3}.keys
    Room.where.not(id: room_ids)
    
  end

  
end