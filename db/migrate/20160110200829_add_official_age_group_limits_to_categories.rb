class AddOfficialAgeGroupLimitsToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :official_min_age_group, :string, default: JUMU_AGE_GROUPS.first
    add_column :categories, :official_max_age_group, :string, default: JUMU_AGE_GROUPS.last
  end
end
