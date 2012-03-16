class AddCertificateDateToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :certificate_date, :date, :after => :ends
  end
end
