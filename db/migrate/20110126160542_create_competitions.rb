# -*- encoding : utf-8 -*-
class CreateCompetitions < ActiveRecord::Migration
  def self.up
    create_table :competitions do |t|
      t.integer :round_id
      t.integer :host_id
      t.date :begins
      t.date :ends

      t.timestamps
    end
  end

  def self.down
    drop_table :competitions
  end
end
