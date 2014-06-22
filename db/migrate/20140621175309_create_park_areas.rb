class CreateParkAreas < ActiveRecord::Migration
  def change
    create_table :park_areas do |t|
      t.string :name
      t.string :address
      t.string :zipcode
      t.decimal :acres
      t.geometry :boundary
      t.integer :park_id
      t.timestamps
    end
  end
end
