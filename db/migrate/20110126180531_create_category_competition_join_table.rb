# -*- encoding : utf-8 -*-
class CreateCategoryCompetitionJoinTable < ActiveRecord::Migration
  def self.up
    create_table :categories_competitions, :id => false do |t|
      t.integer :category_id
      t.integer :competition_id
    end
  end

  def self.down
    drop_table :categories_competitions
  end
end
