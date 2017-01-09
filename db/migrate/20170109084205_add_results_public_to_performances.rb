class AddResultsPublicToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :results_public, :boolean, null: false, default: false
  end
end
