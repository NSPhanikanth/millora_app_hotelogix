json.extract! hotel, :id, :name, :company, :location, :hlx_hotel_id, :hlx_username, :hlx_consumer_key, :hlx_consumer_secret, :hlx_counter_id, :hlx_counter_name, :hlx_counter_email, :hlx_counter_pwd, :hlx_access_key, :hlx_access_secret, :is_active, :created_at, :updated_at
json.url hotel_url(hotel, format: :json)
