class ChangeSignupDeadlineToDate < ActiveRecord::Migration
  def change
    change_column :contests, :signup_deadline, :date
  end
end
