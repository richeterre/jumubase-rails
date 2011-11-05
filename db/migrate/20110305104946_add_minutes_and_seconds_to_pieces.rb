class AddMinutesAndSecondsToPieces < ActiveRecord::Migration
  def self.up
    add_column :pieces, :minutes, :integer, :after => :duration
    add_column :pieces, :seconds, :integer, :after => :minutes
  end

  def self.down
    remove_column :pieces, :seconds
    remove_column :pieces, :minutes
  end
end
