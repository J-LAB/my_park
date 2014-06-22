class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.point :coordinates, geographic: true
      t.string :position
      t.integer :user_id
      t.timestamps
    end
  end
end
