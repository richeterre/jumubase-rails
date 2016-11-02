class RemoveActiveFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :active
  end
end
