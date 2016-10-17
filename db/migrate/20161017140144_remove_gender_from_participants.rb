class RemoveGenderFromParticipants < ActiveRecord::Migration
  def change
    remove_column :participants, :gender
  end
end
