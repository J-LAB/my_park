class AddLimitsToTrails < ActiveRecord::Migration
  def change
    add_column :trails, :limits, :string
  end
end
