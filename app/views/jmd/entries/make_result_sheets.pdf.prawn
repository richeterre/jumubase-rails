# Define font family
pdf.font_families.update(
   "DejaVuSans" => { :bold        => "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf",
                     :italic      => "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Oblique.ttf",
                     :bold_italic => "#{Rails.root}/vendor/assets/fonts/DejaVuSans-BoldOblique.ttf",
                     :normal      => "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf" })
                    
{ "Klassische Kategorien" => @classical_entries,
      "Pop-Kategorien" => @pop_entries }.each do |heading, entries|
  pdf.start_new_page(:layout => :portrait)
  pdf.font "DejaVuSans"
  pdf.text "Ergebnisliste – " + heading, :size => 20
  pdf.pad 20 do
    pdf.text "* mit Weiterleitung zum Bundeswettbewerb"
  end
  entry_rows = entries.map do |e|
   [  
         e.category.name,
         e.age_group,
         e.appearances.role_order.collect { |a| a.participant.full_name + ", " + a.instrument.name + ((a.age_group == e.age_group) ? "" : " (AG #{a.age_group})") + "\n" }.join,
         e.appearances.role_order.collect { |a| "#{a.points}\n" }.join,
         e.appearances.role_order.collect { |a| (a.price.nil? ? "mit gutem Erfolg teilgenommen" : "#{a.price}") + ((a.points && a.points >= 23 && !["Ia", "Ib", "II"].include?(a.age_group) && !["Gesang (Pop) solo", "Drum-Set (Pop) solo", "Gitarre (Pop) solo"].include?(e.category.name)) ? "*" : "") + "\n" }.join
  ]
  end
  pdf.table entry_rows do |table|
   table.columns(0).width = 145
   table.columns(1).width = 25
   table.columns(2).width = 245
   table.columns(3).width = 35
   table.columns(4).width = 70
  end
end