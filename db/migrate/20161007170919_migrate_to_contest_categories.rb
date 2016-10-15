class MigrateToContestCategories < ActiveRecord::Migration
  def up
    drop_table :categories_competitions # Drop old unused join table

    create_table :contest_categories do |t|
      t.references :contest, null: false
      t.references :category, null: false
      t.timestamps
    end

    add_column :performances, :contest_category_id, :integer

    # Migrate data

    # 1. Create set of contest categories by looking at performances
    update <<-SQL
      INSERT INTO contest_categories
      (contest_id, category_id, created_at, updated_at)
      SELECT DISTINCT contest_id, category_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP FROM performances;
    SQL

    # 2. Set the correct contest category on all performances
    update <<-SQL
      UPDATE performances
      SET contest_category_id = cc.id
      FROM contest_categories cc
      WHERE performances.contest_id = cc.contest_id
      AND performances.category_id = cc.category_id
    SQL

    remove_column :performances, :category_id
    remove_column :performances, :contest_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
