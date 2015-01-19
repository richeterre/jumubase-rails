class RemoveVenuesFromPerformances < ActiveRecord::Migration
  def up
    remove_column :performances, :warmup_venue_id
    remove_column :performances, :stage_venue_id
  end

  def down
    add_column :performances, :warmup_venue_id
    add_column :performances, :stage_venue_id
  end
end
