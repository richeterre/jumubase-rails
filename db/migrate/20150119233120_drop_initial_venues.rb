class DropVenues < ActiveRecord::Migration
  def self.up
    drop_table :venues
  end

  def self.down
    create_table :venues do |t|
      t.string :name
      t.integer :host_id
      t.string :address

      t.timestamps
    end
  end
end
