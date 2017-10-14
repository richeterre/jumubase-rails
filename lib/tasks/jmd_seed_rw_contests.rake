namespace :jmd do
  namespace :contests do
    desc "Seed first-round (RW) contests for all hosts"
    task seed_rw: :environment do
      puts "What season would you like to seed RW contests for?"
      season = STDIN.gets.strip.to_i

      puts "What competition year will the contests happen?"
      year = STDIN.gets.strip.to_i

      puts "Please enter the comma-separate category ids for the contests:"
      category_ids = STDIN.gets.strip.split(",").map(&:to_i)

      ActiveRecord::Base.transaction do
        begin
          Host.all.each do |host|

            contest = Contest.create!(
              season: season,
              round: 1,
              host_id: host.id,
              begins: DateTime.new(year, 1, 1),
              ends: DateTime.new(year, 1, 1),
              signup_deadline: DateTime.new(year - 1, 12, 15)
            )

            category_ids.each do |category_id|
              category = Category.find(category_id)
              ContestCategory.create!(
                category_id: category.id,
                contest_id: contest.id
              )
            end

            puts "✓ Created contest #{contest.name} with contest categories"
          end
        rescue Exception => e
          puts "✗ Could not seed contests as the following error occured:"
          puts e
          raise ActiveRecord::Rollback
        end
      end
    end
  end
end
