class CreateParkEntrances < ActiveRecord::Migration
  def change
    create_table :park_entrances do |t|
      t.string :type
      t.string :address
      t.boolean :primary
      t.string :features
      t.point :coordinates, geographic: true
      t.integer :park_id
      t.timestamps
    end
  end
end
