class AddHotelReferenceToRoomType < ActiveRecord::Migration[7.0]
  def change
    add_reference :room_types, :hotel, foreign_key: true
  end
end
