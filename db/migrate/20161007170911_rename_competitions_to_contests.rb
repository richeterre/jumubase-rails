class RenameCompetitionsToContests < ActiveRecord::Migration
  def change
    rename_table :competitions, :contests
    rename_column :performances, :competition_id, :contest_id
  end
end
