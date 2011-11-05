class RemovePointsFromEntries < ActiveRecord::Migration
  def self.up
    remove_column :entries, :points
  end

  def self.down
    add_column :entries, :points, :after => :stage_time
  end
end
