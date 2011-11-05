class AddEditCodeIndex < ActiveRecord::Migration
  def self.up
    add_index :entries, :edit_code, :unique => true
  end

  def self.down
    remove_index :entries, :edit_code
  end
end
