namespace :jmd do
  namespace :performances do
    desc "List performances that advance to third round (BW) from current LW"
    task list_current_bw: :environment do
      contest = Contest.seasonal_in_round(2).first

      puts "#{contest.name}: Weiterleitungen zum BW"
      advancing = contest.performances.select do |p| p.advances_to_next_round? end
      puts "(Gesamt: #{advancing.size} Vorspiele)"

      puts "---"
      puts "\n"

      advancing.each do |p|
        puts "Kategorie \"#{p.category.name}\", AG #{p.age_group}"
        puts p.associated_host.name
        puts p.appearances.with_role(["soloist", "ensemblist"]).role_order
          .map { |a| a.participant }
          .map { |p| "#{p.full_name} (*#{p.birthdate.strftime("%d.%m.%Y")}), #{p.email}, Tel. #{p.phone}" }
          .join("\n")
        puts "\n"
      end
      # puts p.participants.map(&:full_name).join(", ")
    end
  end
end
