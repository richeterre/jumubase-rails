class AddEditCodeToEntries < ActiveRecord::Migration
  def self.up
    add_column :entries, :edit_code, :string, :after => :id
  end

  def self.down
    remove_column :entries, :edit_code
  end
end
