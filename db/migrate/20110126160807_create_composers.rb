# -*- encoding : utf-8 -*-
class CreateComposers < ActiveRecord::Migration
  def self.up
    create_table :composers do |t|
      t.string :name
      t.string :born
      t.string :died

      t.timestamps
    end
  end

  def self.down
    drop_table :composers
  end
end
