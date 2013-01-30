class AddPredecessorIdToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :predecessor_id, :integer
  end
end
