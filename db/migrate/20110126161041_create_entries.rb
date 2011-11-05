# -*- encoding : utf-8 -*-
class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :category_id
      t.integer :competition_id
      t.integer :venue_id
      t.datetime :warmup_time
      t.datetime :stage_time
      t.integer :points

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
