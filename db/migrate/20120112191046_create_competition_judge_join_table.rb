class CreateCompetitionJudgeJoinTable < ActiveRecord::Migration
  def change
    create_table :competitions_judges, :id => false do |t|
      t.integer :competition_id
      t.integer :judge_id
    end
  end
end
