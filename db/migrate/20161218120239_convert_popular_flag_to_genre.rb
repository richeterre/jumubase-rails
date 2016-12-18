class ConvertPopularFlagToGenre < ActiveRecord::Migration
  def up
    add_column :categories, :genre, :string

    # Migrate data
    update <<-SQL
      UPDATE categories
      SET genre = 'classical'
      WHERE popular = FALSE AND name != '"Kinder musizieren"'
    SQL
    update <<-SQL
      UPDATE categories
      SET genre = 'kimu'
      WHERE name = '"Kinder musizieren"'
    SQL
    update <<-SQL
      UPDATE categories
      SET genre = 'popular'
      WHERE popular = TRUE
    SQL

    remove_column :categories, :popular
  end

  def down
    add_column :categories, :popular, :boolean

    # Migrate data
    update <<-SQL
      UPDATE categories
      SET popular = TRUE
      WHERE genre = 'popular'
    SQL
    update <<-SQL
      UPDATE categories
      SET popular = FALSE
      WHERE genre != 'popular'
    SQL

    remove_column :categories, :genre
  end
end
