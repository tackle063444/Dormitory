json.extract! rent, :id, :Room_id, :User_id, :rent_start, :rent_end, :rent_history, :created_at, :updated_at
json.url rent_url(rent, format: :json)
