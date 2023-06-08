class Room < ApplicationRecord
  belongs_to :hall
  has_many :rents, foreign_key: :room_id
  has_many :bills

  def room_name
    "#{hall.hall_name} #{room_num}"
  end

  def self.check_room_user_relation
    room_ids = Rent.joins(:room).group(:room_id).count.select {|k,v| v > 2}.keys
    Room.where.not(id: room_ids)
  end

  def occupied_count
    rents.count
  end
  
  def room_show_status
    occupied_count = rents.count
    
    if occupied_count == 3
      room_status = "ห้องเต็ม"
    elsif occupied_count == 2
      room_status = "ว่าง 1"
    elsif occupied_count == 1
      room_status = "ว่าง 2"
    else
      room_status = "ว่าง 3"
    end
    
    self.room_status = room_status 
    room_status 
  end
  
  

  
end