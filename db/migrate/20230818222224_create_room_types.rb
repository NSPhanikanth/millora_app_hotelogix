class CreateRoomTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :room_types do |t|
      t.string :name
      t.string :hlx_room_type_id
      t.string :hlx_room_type_name
      t.integer :max_occupancy
      t.boolean :is_split_allowed, default: false
      t.boolean :is_active, default: true
      t.timestamps
    end
  end
end
