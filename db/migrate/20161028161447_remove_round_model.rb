class RemoveRoundModel < ActiveRecord::Migration
  def up
    # Add new columns
    add_column :contests, :round, :integer
    add_column :categories, :max_round, :integer

    # Migrate data
    update <<-SQL
      UPDATE contests
      SET round = r.level
      FROM rounds r
      WHERE contests.round_id = r.id
    SQL
    update <<-SQL
      UPDATE categories
      SET max_round = r.level
      FROM rounds r
      WHERE categories.max_round_id = r.id
    SQL

    # Rename indices
    remove_index :categories, :max_round_id
    add_index :categories, :max_round

    # Clean up
    remove_column :contests, :round_id
    remove_column :categories, :max_round_id
    drop_table :rounds
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
