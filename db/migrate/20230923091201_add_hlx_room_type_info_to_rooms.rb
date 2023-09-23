class AddHlxRoomTypeInfoToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :hlx_room_type_id, :string
    add_column :rooms, :hlx_room_type_name, :string
  end
end
