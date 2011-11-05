class AddSlugToVenues < ActiveRecord::Migration
  def self.up
    add_column :venues, :slug, :string, :after => :name
  end

  def self.down
    remove_column :venues, :slug
  end
end
