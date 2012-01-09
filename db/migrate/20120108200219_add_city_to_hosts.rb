class AddCityToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :city, :string, :after => :name
  end
end
