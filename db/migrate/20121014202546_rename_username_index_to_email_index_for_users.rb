class RenameUsernameIndexToEmailIndexForUsers < ActiveRecord::Migration
  def change
    rename_index :users, 'index_users_on_username', 'index_users_on_email'
  end
end
