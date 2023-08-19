json.extract! room, :id, :room_name, :room_type, :hotel_id, :occupancy, :hlx_hotel_id, :hlx_room_id, :hlx_room_name, :hlx_room_type, :hlx_occupancy, :is_active, :created_at, :updated_at
json.url room_url(room, format: :json)
