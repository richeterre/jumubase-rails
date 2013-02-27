namespace :jmd do
  namespace :performances do
    desc "Resave all performances, leaving their timestamps untouched"
    task resave: :environment do
      Performance.all.each do |performance|
        age_group = performance.age_group
        if performance.save_without_timestamping
          new_age_group = performance.age_group
          if new_age_group != age_group
            puts "Resaved performance #{performance.id} and updated age group from #{age_group} to #{new_age_group}"
          else
            puts "Resaved performance #{performance.id}"
          end
        else
          puts "Failed to resave performance #{performance.id}"
        end
      end
    end
  end
end
