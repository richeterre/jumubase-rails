class AddTimeZoneToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :time_zone, :string, :after => :country_id, :default => "Europe/Berlin"
  end
end
