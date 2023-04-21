json.extract! bill_list, :id, :list_typeName, :unit_price, :created_at, :updated_at
json.url bill_list_url(bill_list, format: :json)
