class AddFirstCompetitionIdToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :first_competition_id, :integer, :after => :competition_id
  end

  def self.down
    remove_column :entries, :first_competition_id
  end
end
