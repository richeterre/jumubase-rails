# Define font family
pdf.font_families.update(
  "DejaVuSans" => {
    bold: "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf",
    italic: "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Oblique.ttf",
    bold_italic: "#{Rails.root}/vendor/assets/fonts/DejaVuSans-BoldOblique.ttf",
    normal: "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
  }
)

pdf.start_new_page(layout: :portrait)
pdf.font "DejaVuSans"
pdf.text "#{@contest_category.name}, Altersgruppe #{@age_group}", size: 20
pdf.pad 20 do
  pdf.text "(* = mit Weiterleitung zum #{@contest.next_round_name})"
end
performances_rows = @performances.map do |e|
  [
    e.appearances.role_order.collect { |a| a.participant.full_name + ", " + a.instrument.name + ((a.age_group == e.age_group) ? "" : " (AG #{a.age_group})") + "\n" }.join,
    e.appearances.role_order.collect { |a| "#{a.points}\n" }.join,
    e.appearances.role_order.collect do |a|
      (a.prize_or_predicate.nil? ? "teilgenommen" : "#{a.prize_or_predicate}") + (a.advances_to_next_round? ? "*" : "") + "\n"
    end.join
  ]
end
pdf.table performances_rows do |table|
 table.columns(0).width = 280
 table.columns(1).width = 35
 table.columns(2).width = 205
end
