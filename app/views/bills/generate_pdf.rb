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
  bounding_box([gap, cursor - gap], width: 300) do
    text 'Stretchy height'
  end
  table(data) do
    # กำหนดความกว้างของคอลัมน์
    column_widths

    
    # กำหนดลักษณะของแถวแรกของตาราง
    row(0).font_style = :bold
    row(0).background_color = 'dddddd'
  end
end
