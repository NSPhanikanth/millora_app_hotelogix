class AddCaratlaneTestClient < ActiveRecord::Migration[7.0]
  def change
    Client.create(name: "test", display_name: "Test", logo: "caratlane.png", logo_2x: "caratlane_2x.png", access_key: "D1pOQgmP50Ql00J5")
  end
end
