class RemoveWarmupTimeFromPerformances < ActiveRecord::Migration
  def change
    remove_column :performances, :warmup_time
  end
end
