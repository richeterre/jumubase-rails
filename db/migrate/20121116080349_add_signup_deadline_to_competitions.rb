class AddSignupDeadlineToCompetitions < ActiveRecord::Migration
  def change
    add_column :competitions, :signup_deadline, :datetime
  end
end
