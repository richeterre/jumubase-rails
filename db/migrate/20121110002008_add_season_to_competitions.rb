class AddSeasonToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :season, :integer, after: :id
  end
end
