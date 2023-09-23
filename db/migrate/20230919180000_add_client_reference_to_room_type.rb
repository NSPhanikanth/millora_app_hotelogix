class AddClientReferenceToRoomType < ActiveRecord::Migration[7.0]
  def change
    add_reference :room_types, :client, foreign_key: true
  end
end
