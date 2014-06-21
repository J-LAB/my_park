class RenameImageTagsToTags < ActiveRecord::Migration
  def change
    rename_table :image_tags, :tags
    add_column :tags, :type, :string
  end
end
