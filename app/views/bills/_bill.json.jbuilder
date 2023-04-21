json.extract! bill, :id, :Bill_type_id, :Rent_id, :List_id, :bill_date, :bill_no, :bill_total, :bill_remark, :created_at, :updated_at
json.url bill_url(bill, format: :json)
