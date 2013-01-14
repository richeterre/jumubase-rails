namespace :jmd do
  namespace :performances do
    desc "Resave all performances, leaving their timestamps untouched"
    task resave: :environment do
      Performance.all.each do |performance|
        if performance.save_without_timestamping
          puts "Resaved performance #{performance.id}"
        else
          puts "Failed to resave performance #{performance.id}"
        end
      end
    end
  end
end
