class AddWarmupVenueIdToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :warmup_venue_id, :integer, :after => :competition_id
  end

  def self.down
    remove_column :entries, :warmup_venue_id
  end
end
