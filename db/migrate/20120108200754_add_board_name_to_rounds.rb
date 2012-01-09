class AddBoardNameToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :board_name, :string, :after => :slug
  end
end
