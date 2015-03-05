class AddStageVenueToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :stage_venue_id, :integer
    add_index :performances, :stage_venue_id
  end
end
