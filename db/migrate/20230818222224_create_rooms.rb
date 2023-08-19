class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :room_name
      t.string :room_type
      t.references :hotel, null: false, foreign_key: true
      t.integer :occupancy
      t.string :hlx_hotel_id
      t.string :hlx_room_id
      t.string :hlx_room_name
      t.string :hlx_room_type
      t.integer :hlx_occupancy
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
