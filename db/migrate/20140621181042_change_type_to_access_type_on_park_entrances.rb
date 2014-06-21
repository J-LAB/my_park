class ChangeTypeToAccessTypeOnParkEntrances < ActiveRecord::Migration
  def change
    rename_column :park_entrances, :type, :access_type
    rename_column :trails, :type, :trail_type
  end
end
