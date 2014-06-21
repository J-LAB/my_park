class CreateImageTags < ActiveRecord::Migration
  def change
    create_table :image_tags do |t|
      t.point :coordinates, geographic: true
      t.string :description
      t.integer :uploader_id
      t.integer :taggable_id
      t.string :taggable_type

      t.timestamps
    end
  end
end
