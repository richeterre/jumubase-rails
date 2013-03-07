# Define font family
pdf.font_families.update(
  "DejaVuSans" => {
    bold: "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf",
    italic: "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Oblique.ttf",
    bold_italic: "#{Rails.root}/vendor/assets/fonts/DejaVuSans-BoldOblique.ttf",
    normal: "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
  }
)

{ "Test" => @performances }.each do |heading, performances|
  pdf.start_new_page(layout: :portrait)
  pdf.font "DejaVuSans"
  pdf.text "Ergebnisliste – " + heading, size: 20
  pdf.pad 20 do
    pdf.text "* mit Weiterleitung zum Bundeswettbewerb"
  end
  performances_rows = performances.map do |e|
    [
      e.category.name,
      e.age_group,
      e.appearances.role_order.collect { |a| a.participant.full_name + ", " + a.instrument.name + ((a.age_group == e.age_group) ? "" : " (AG #{a.age_group})") + "\n" }.join,
      e.appearances.role_order.collect { |a| "#{a.points}\n" }.join,
      e.appearances.role_order.collect { |a| (a.prize.nil? ? "mit gutem Erfolg teilgenommen" : "#{a.prize}") + (a.advances_to_next_round? ? "*" : "") + "\n" }.join
    ]
  end
  pdf.table performances_rows do |table|
   table.columns(0).width = 145
   table.columns(1).width = 25
   table.columns(2).width = 245
   table.columns(3).width = 35
   table.columns(4).width = 70
  end
end
