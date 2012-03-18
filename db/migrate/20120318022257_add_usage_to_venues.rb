class AddUsageToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :usage, :string, :after => :address
  end
end
