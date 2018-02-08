namespace :jmd do
  namespace :contests do
    desc "Add contest categories to a contest"
    task add_ccs: :environment do
      puts "What contest would you like to add the contest categories to?"
      contest_id = STDIN.gets.strip.to_i

      puts "Please enter the comma-separate category ids:"
      category_ids = STDIN.gets.strip.split(",").map(&:to_i)

      ActiveRecord::Base.transaction do
        begin
          contest = Contest.find(contest_id)

          category_ids.each do |category_id|
            category = Category.find(category_id)
            ContestCategory.create!(
              category_id: category.id,
              contest_id: contest.id
            )
          end

          puts "✓ Added contest categories to #{contest.name}"
        rescue Exception => e
          puts "✗ Could not add contest categories as the following error occured:"
          puts e
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
