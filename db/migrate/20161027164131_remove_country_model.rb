class RemoveCountryModel < ActiveRecord::Migration
  def up
    add_column :hosts, :country_code, :string

    # Migrate data
    update <<-SQL
      UPDATE hosts
      SET country_code = c.country_code
      FROM countries c
      WHERE hosts.country_id = c.id
    SQL

    remove_column :hosts, :country_id
    drop_table :countries
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
