require 'prawn'

Prawn::Document.generate("bill.pdf") do
  data = [
    ["หมายเลขห้อง", @bill.rent.room.room_num],
    ["ใบแจ้งค่าบริการห้องพัก", @bill.room.hall.hall_address],
    ["ชื่อผู้เช่า", @bill.rent.user.user_fname],
    ["ที่อยู่", @bill.rent.user.user_address],
    ["เบอร์โทร", @bill.rent.user.user_tel],
    ["วันที่", @bill.bill_date.to_s],
    ["เลขที่บิล", @bill.bill_no],
    ["รายการ", @bill.bill_list.list_typeName],
    ["หน่วยเดิม", @bill.old_unit],
    ["หน่วยใหม่", @bill.new_unit],
    ["รวม", @bill.bill_total],
    ["หมายเหตุ", @bill.bill_remark]
  ]

  table(data, header: true, cell_style: { border_width: 1 })
end