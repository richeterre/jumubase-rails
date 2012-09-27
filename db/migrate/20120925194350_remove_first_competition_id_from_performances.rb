class RemoveFirstCompetitionIdFromPerformances < ActiveRecord::Migration
  def change
    remove_column :performances, :first_competition_id
  end
end
