json.extract! user, :id, :user_fname, :user_lname, :user_address, :user_tel, :created_at, :updated_at
json.url user_url(user, format: :json)
