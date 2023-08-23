class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :room_name
      t.references :room_type, null: false, foreign_key: true
      t.references :hotel, null: false, foreign_key: true
      t.string :hlx_hotel_id
      t.string :hlx_room_id
      t.string :hlx_room_name
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
