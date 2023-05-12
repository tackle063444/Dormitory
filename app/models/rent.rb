class Rent < ApplicationRecord
  belongs_to :room
  belongs_to :user

  def user_id_to_select_option
    excluded_ids = self.user_id.nil? ? [] : [self.user_id]
    excluded_ids += Rent.where.not(id: self.id).pluck(:user_id)  
    User.where.not(id: excluded_ids).pluck(:user_fname, :id) # ดึงข้อมูล user_fname และ id ของ user ที่ไม่อยู่ใน excluded_ids
  end



end