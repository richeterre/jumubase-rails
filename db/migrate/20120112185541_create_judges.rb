class CreateJudges < ActiveRecord::Migration
  def change
    create_table :judges do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.integer :country_id

      t.timestamps
    end
  end
end
