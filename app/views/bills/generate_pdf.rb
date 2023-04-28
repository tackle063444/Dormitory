require 'prawn'
require 'prawn/table'

# ข้อมูลตาราง
data = [
  ["Name", "Age", "Gender"],
  ["Alice", "25", "Female"],
  ["Bob", "30", "Male"],
  ["Charlie", "35", "Male"],
  ["Diana", "40", "Fem11ale"]
]

# สร้างไฟล์ PDF ด้วย prawn
Prawn::Document.generate('table.pdf') do
  # เพิ่มตารางลงในไฟล์ PDF ด้วย prawn-table
  table(data) do
    # กำหนดความกว้างของคอลัมน์
    column_widths [100, 50, 50]
    
    # กำหนดลักษณะของแถวแรกของตาราง
    row(0).font_style = :bold
    row(0).background_color = 'dddddd'
  end
end

