# -*- encoding : utf-8 -*-
class CreateHostUserJoinTable < ActiveRecord::Migration
  def self.up
    create_table :hosts_users, :id => false do |t|
      t.integer :host_id
      t.integer :user_id
    end
  end

  def self.down
    drop_table :hosts_users
  end
end
