class AddAgeGroupToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :age_group, :string
  end
end
