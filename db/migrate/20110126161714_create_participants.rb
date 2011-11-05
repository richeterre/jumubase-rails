# -*- encoding : utf-8 -*-
class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.date :birthdate
      t.string :street
      t.string :postal_code
      t.string :city
      t.integer :country_id
      t.string :phone
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
