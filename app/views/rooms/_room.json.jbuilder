json.extract! room, :id, :Hall_id, :User_id, :room_num, :room_status, :created_at, :updated_at
json.url room_url(room, format: :json)
