class RemoveDurationFromPieces < ActiveRecord::Migration
  def change
    remove_column :pieces, :duration
  end
end
