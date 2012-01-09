# Grading table
pdf.start_new_page(:layout => :landscape)
pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"

entry_rows = @entries.map do |e|
  [  
        e.category.name,
        e.age_group,
        e.appearances.role_order.collect { |a| a.participant.full_name + ((a.age_group == e.age_group) ? "" : " (AG #{a.age_group})") + "\n" }.join,
        "",
        "",
        "",
        "",
        ""
  ]
end
pdf.table entry_rows do |table|
  table.columns(0).width = 100
  table.columns(1).width = 25
  table.columns(2).width = 200
  table.columns(3..7).width = 75
end

# Entry sheets
@entries.each do |entry|
  pdf.start_new_page(:layout => :portrait)
  pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
  pdf.font_size = 11
  pdf.default_leading = 2
  
  # Info
  pdf.bounding_box [50, 775], :width => 400, :height => 80 do
    pdf.text_box "Kategorie: " + entry.category.name + "\nAltersgruppe " + entry.age_group, :at => [0, pdf.bounds.bottom + 2 * pdf.font.height]
    if entry.stage_time.nil?
      stage_time = ""
    else
      stage_time = l entry.stage_time, :format => :short
    end
    # Display host of entry's first competition round, if applicable
    if entry.competition.round.level == 2
      pdf.text_box entry.first_competition.host.name + "\n#{stage_time}", :at => [250, pdf.bounds.bottom + 2 * pdf.font.height], :align => :right
    end
  
    pdf.stroke do
      pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
    end
  end
  
  # Participants
  pdf.bounding_box [50, 650], :width => 400, :height => 550 do
    pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf"
    entry.appearances.role_order.each do |appearance|
      if appearance.accompaniment?
        pdf.indent(10) do
          if appearance.age_group != entry.age_group
            pdf.text appearance.participant.full_name + ", " + appearance.instrument.name + " (AG #{appearance.age_group})"
          else
            pdf.text appearance.participant.full_name + ", " + appearance.instrument.name
          end
        end
      else
        pdf.text appearance.participant.full_name + ", " + appearance.instrument.name
      end
    end
    pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
    pdf.move_down 100
    entry.pieces.each do |piece|
      pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf"
      if piece.composer.born.blank?
        pdf.text piece.composer.name
      else
        pdf.text "#{piece.composer.name} (#{piece.composer.born}–#{piece.composer.died})"
      end
      pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
      pdf.text piece.title
      pdf.text "#{format_duration(piece.duration)}, Epoche #{piece.epoch.slug}"
      pdf.move_down pdf.font.height
    end
  end
end