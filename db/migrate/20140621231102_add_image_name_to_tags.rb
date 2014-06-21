class AddImageNameToTags < ActiveRecord::Migration
  def change
    add_column :tags, :image_file_name, :string
  end
end
