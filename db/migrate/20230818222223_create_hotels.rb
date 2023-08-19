class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :company
      t.string :location
      t.string :hlx_hotel_id
      t.string :hlx_username
      t.string :hlx_consumer_key
      t.string :hlx_consumer_secret
      t.string :hlx_counter_id
      t.string :hlx_counter_name
      t.string :hlx_counter_email
      t.string :hlx_counter_pwd
      t.string :hlx_access_key
      t.string :hlx_access_secret
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
