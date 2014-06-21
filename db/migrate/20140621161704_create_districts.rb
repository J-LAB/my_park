class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.geometry :boundary, geographic: true
      t.timestamps
    end
  end
end
