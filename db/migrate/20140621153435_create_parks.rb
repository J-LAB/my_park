class CreateParks < ActiveRecord::Migration
  def change
    create_table :parks do |t|
      t.string :name
      t.string :type
      t.string :material
      t.integer :width
      t.decimal :length
      t.integer :park_id
      t.geometry :, geographic: true
      t.timestamps
    end
  end
end
