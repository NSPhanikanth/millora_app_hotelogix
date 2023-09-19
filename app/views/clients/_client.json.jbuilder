json.extract! client, :id, :name, :display_name, :logo, :access_key, :is_active, :created_at, :updated_at
json.url client_url(client, format: :json)
