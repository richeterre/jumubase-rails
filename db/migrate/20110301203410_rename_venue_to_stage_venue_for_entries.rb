class RenameVenueToStageVenueForEntries < ActiveRecord::Migration
  def self.up
    rename_column :entries, :venue_id, :stage_venue_id
  end

  def self.down
    rename_column :entries, :stage_venue_id, :venue_id
  end
end
