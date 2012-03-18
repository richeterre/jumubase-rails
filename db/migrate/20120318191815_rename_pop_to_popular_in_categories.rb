class RenamePopToPopularInCategories < ActiveRecord::Migration
  def change
    rename_column :categories, :pop, :popular
  end
end
