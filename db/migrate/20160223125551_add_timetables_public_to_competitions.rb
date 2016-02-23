class AddTimetablesPublicToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :timetables_public, :boolean, default: false
  end
end
