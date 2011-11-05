class AddSlugToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :slug, :string, :after => :name
  end

  def self.down
    remove_column :categories, :slug
  end
end
