class RenameEntryToPerformance < ActiveRecord::Migration
  def change
    rename_table :entries, :performances
  end
end
