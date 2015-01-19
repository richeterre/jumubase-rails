# Grading table
pdf.start_new_page(layout: :landscape)
pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"

performance_rows = @performances.map do |p|
  [
        p.category.name,
        p.age_group,
        p.appearances.role_order.collect { |a| a.participant.full_name + ((a.age_group == p.age_group) ? "" : " (AG #{a.age_group})") + "\n" }.join,
        "",
        "",
        "",
        "",
        ""
  ]
end
pdf.table performance_rows do |table|
  table.columns(0).width = 100
  table.columns(1).width = 25
  table.columns(2).width = 200
  table.columns(3..7).width = 75
end

# Performance sheets
@performances.each do |performance|
  pdf.start_new_page(layout: :portrait)
  pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
  pdf.font_size = 11
  pdf.default_leading = 2

  # Info
  pdf.bounding_box [50, 775], width: 400, height: 80 do
     pdf.text_box "Kategorie: " + performance.category.name + "\nAltersgruppe " + performance.age_group, at: [0, pdf.bounds.bottom + 2 * pdf.font.height]

    if performance.stage_time.nil?
      stage_time = ""
    else
      stage_time = l performance.stage_time, format: :short
    end
    # Add host of performance's first competition round if applicable
    if performance.predecessor
      pdf.text_box performance.predecessor.associated_host.name + "\n#{stage_time}", at: [250, pdf.bounds.bottom + 2 * pdf.font.height], align: :right
    else
      pdf.text_box "#{stage_time}", at: [250, pdf.bounds.bottom + pdf.font.height], align: :right
    end

    pdf.stroke do
      pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
    end
  end

  # Participants
  pdf.bounding_box [50, 650], width: 400, height: 550 do
    pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf"
    performance.appearances.role_order.each do |appearance|
      if appearance.accompaniment?
        pdf.indent(10) do
          if appearance.age_group != performance.age_group
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
    performance.pieces.each do |piece|
      pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf"
      if piece.composer_born.blank?
        pdf.text piece.composer_name
      else
        pdf.text "#{piece.composer_name} (#{piece.composer_born}–#{piece.composer_died})"
      end
      pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
      pdf.text piece.title
      pdf.text "#{format_duration(piece.duration)}, Epoche #{piece.epoch.slug}"
      pdf.move_down pdf.font.height
    end
  end
end
