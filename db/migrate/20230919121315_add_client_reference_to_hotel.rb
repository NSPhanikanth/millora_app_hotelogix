class AddClientReferenceToHotel < ActiveRecord::Migration[7.0]
  def change
    add_reference :hotels, :client, foreign_key: true
  end
end
