class RemoveAppearanceRoles < ActiveRecord::Migration
  def self.up
    add_column :appearances, :participant_role, :string

    # Migrate data
    update <<-SQL
      UPDATE appearances
      SET participant_role = 'soloist'
      WHERE role_id IN (
        SELECT roles.id FROM roles WHERE roles.slug = 'S'
      );
    SQL
    update <<-SQL
      UPDATE appearances
      SET participant_role = 'accompanist'
      WHERE role_id IN (
        SELECT roles.id FROM roles WHERE roles.slug = 'B'
      );
    SQL
    update <<-SQL
      UPDATE appearances
      SET participant_role = 'ensemblist'
      WHERE role_id IN (
        SELECT roles.id FROM roles WHERE roles.slug = 'E'
      );
    SQL


    remove_column :appearances, :role_id
    drop_table :roles
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
