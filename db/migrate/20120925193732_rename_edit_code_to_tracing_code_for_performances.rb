class RenameEditCodeToTracingCodeForPerformances < ActiveRecord::Migration
  def change
    rename_column :performances, :edit_code, :tracing_code
    rename_index :performances, 'index_entries_on_edit_code', 'index_performances_on_tracing_code'
  end
end
