class ChangeDescriptionToComments < ActiveRecord::Migration
  def change
    rename_column :tags, :description, :comments
  end
end
