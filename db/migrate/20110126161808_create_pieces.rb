# -*- encoding : utf-8 -*-
class CreatePieces < ActiveRecord::Migration
  def self.up
    create_table :pieces do |t|
      t.string :title
      t.integer :composer_id
      t.integer :entry_id
      t.integer :epoch_id
      t.string :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :pieces
  end
end
