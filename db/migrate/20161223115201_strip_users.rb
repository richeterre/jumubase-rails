class StripUsers < ActiveRecord::Migration
  def up
    remove_column :users, :password_digest
    remove_column :users, :remember_token
    remove_column :users, :encrypted_password
    remove_column :users, :salt
    remove_column :users, :last_login
  end

  def down
    change_table :users do |t|
      t.string :password_digest
      t.string :remember_token
      t.string :encrypted_password
      t.string :salt
      t.datetime :last_login
    end

    add_index :users, :remember_token
  end
end
