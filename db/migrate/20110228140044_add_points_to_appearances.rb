class AddPointsToAppearances < ActiveRecord::Migration
  def self.up
    add_column :appearances, :points, :integer, :after => :role_id
  end

  def self.down
    remove_column :appearances, :points
  end
end
