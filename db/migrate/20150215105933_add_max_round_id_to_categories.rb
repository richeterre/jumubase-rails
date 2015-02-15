class AddMaxRoundIdToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :max_round_id, :integer
    add_index :categories, :max_round_id
  end
end
