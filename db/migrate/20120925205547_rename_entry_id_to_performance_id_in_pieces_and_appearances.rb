class RenameEntryIdToPerformanceIdInPiecesAndAppearances < ActiveRecord::Migration
  def change
    rename_column :appearances, :entry_id, :performance_id
    rename_column :pieces, :entry_id, :performance_id
  end
end
