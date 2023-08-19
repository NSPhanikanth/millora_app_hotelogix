class AddIsSplitAllowedToRooms < ActiveRecord::Migration[7.0]
  def change
    add_column :rooms, :is_split_allowed, :boolean, default: false
  end
end
