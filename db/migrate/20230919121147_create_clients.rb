class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :display_name
      t.string :logo
      t.string :logo_2x
      t.string :access_key, null: false
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
