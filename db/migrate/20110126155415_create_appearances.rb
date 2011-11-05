# -*- encoding : utf-8 -*-
class CreateAppearances < ActiveRecord::Migration
  def self.up
    create_table :appearances do |t|
      t.integer :entry_id
      t.integer :participant_id
      t.integer :instrument_id
      t.integer :role_id

      t.timestamps
    end
    add_index :appearances, :entry_id
    add_index :appearances, :participant_id
    add_index :appearances, [:entry_id, :participant_id], :unique => true
  end

  def self.down
    drop_table :appearances
  end
end
