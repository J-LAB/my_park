class CreateParks < ActiveRecord::Migration
  def change
    create_table :parks do |t|
      t.string :name
      t.string :address
      t.string :zipcode
      t.decimal :acres
      t.geometry :boundary
      t.integer :district_id
      t.timestamps
    end
  end
end
