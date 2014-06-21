class CreateTrails < ActiveRecord::Migration
  def change
    create_table :trails do |t|
      t.string :name
      t.string :type
      t.string :material
      t.integer :width
      t.decimal :length
      t.geometry :geospatial_data, geographic: true
      t.integer :park_id
      t.timestamps
    end
  end
end
