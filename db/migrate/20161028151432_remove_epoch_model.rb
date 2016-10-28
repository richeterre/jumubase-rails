class RemoveEpochModel < ActiveRecord::Migration
  def up
    add_column :pieces, :epoch, :string

    # Migrate data
    update <<-SQL
      UPDATE pieces
      SET epoch = e.slug
      FROM epoches e
      WHERE pieces.epoch_id = e.id
    SQL

    remove_column :pieces, :epoch_id
    drop_table :epoches
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
