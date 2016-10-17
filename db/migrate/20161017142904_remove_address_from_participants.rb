class RemoveAddressFromParticipants < ActiveRecord::Migration
  def change
    remove_column :participants, :street
    remove_column :participants, :postal_code
    remove_column :participants, :city
    remove_column :participants, :country_id
  end
end
