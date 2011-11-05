# -*- encoding : utf-8 -*-
class AddSaltToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :salt, :string, :after => :admin
  end

  def self.down
    remove_column :users, :salt
  end
end
