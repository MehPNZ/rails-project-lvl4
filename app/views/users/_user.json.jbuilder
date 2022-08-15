json.extract! user, :id, :email, :nickname, :string, :token, :created_at, :updated_at
json.url user_url(user, format: :json)
