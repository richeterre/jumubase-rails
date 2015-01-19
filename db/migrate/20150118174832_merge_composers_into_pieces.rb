class MergeComposersIntoPieces < ActiveRecord::Migration
  def up
    add_column :pieces, :composer_name, :string
    add_column :pieces, :composer_born, :string
    add_column :pieces, :composer_died, :string
    execute "UPDATE pieces AS p SET composer_name = c.name FROM composers AS c WHERE p.id = c.piece_id"
    execute "UPDATE pieces AS p SET composer_born = c.born FROM composers AS c WHERE p.id = c.piece_id"
    execute "UPDATE pieces AS p SET composer_died = c.died FROM composers AS c WHERE p.id = c.piece_id"
    drop_table :composers
  end

  def down
    create_table :composers do |t|
      t.string :name
      t.string :born
      t.string :died

      t.timestamps

      t.integer :piece_id
    end
    add_index "composers", ["piece_id"], name: "index_composers_on_piece_id"

    execute "INSERT INTO composers (piece_id, name, born, died, created_at, updated_at) SELECT DISTINCT id, composer_name, composer_born, composer_died, created_at, updated_at FROM pieces"
    remove_column :pieces, :composer_name
    remove_column :pieces, :composer_born
    remove_column :pieces, :composer_died
  end
end
