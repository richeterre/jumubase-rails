class AddRememberTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_token, :string, after: :password_digest
    add_index :users, :remember_token
  end
end
