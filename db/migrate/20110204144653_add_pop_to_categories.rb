class AddPopToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :pop, :boolean, :after => :ensemble
  end

  def self.down
    remove_column :categories, :pop
  end
end
