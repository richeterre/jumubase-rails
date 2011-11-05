# -*- encoding : utf-8 -*-
class CreateRounds < ActiveRecord::Migration
  def self.up
    create_table :rounds do |t|
      t.integer :level
      t.string :name
      t.string :slug

      t.timestamps
    end
  end

  def self.down
    drop_table :rounds
  end
end
