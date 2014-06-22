class AddClimbAndDescentToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :climb, :decimal
    add_column :trails, :descent, :decimal
  end
end
