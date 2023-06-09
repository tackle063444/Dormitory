class Bill < ApplicationRecord
  belongs_to :rent, optional: true
  has_many :head_lists, dependent: :destroy
  accepts_nested_attributes_for :head_lists, allow_destroy: true
  belongs_to :hall, optional: true
  belongs_to :room, optional: true
  before_save :get_bill_no

  def get_bill_no
    if self.bill_no.nil? || self.bill_no.blank? || self.bill_date_changed?
      room = Room.find(room_id)
      hall = Hall.find(room.hall_id)
      codename_hall = hall.codename_hall
      new_year = bill_date.strftime("%Y")
      new_month = bill_date.strftime("%m")
      new_bill_no = "#{codename_hall}-#{new_year.slice(2,2)}#{new_month}-#{room.room_num}"
      self.bill_no = new_bill_no
    end
  end
  
  
  def form_select_text
    case form_select 
    when 'form1' 
      "ใบแจ้งค่าบริการห้องพัก"
    when 'form2' 
      "ใบเสร็จรับเงินค่าบริการห้องพัก"
    when 'form3' 
      "ใบเสร็จรับเงินค่ามัดจำห้องพัก"
    when 'form4' 
     "ใบแจ้งคืนค่าบริการห้องพัก"
    end 
  end

  

end
