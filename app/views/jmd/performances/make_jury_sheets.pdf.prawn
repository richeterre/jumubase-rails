# Constants

default_color = "000000"
muted_color = "999999"

# Grading table

pdf.start_new_page(layout: :landscape)
pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
pdf.fill_color default_color

performance_rows = @performances.map do |p|
  [
        p.contest_category.name,
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
  table.columns(0).width = 130
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
     pdf.text_box "Kategorie: " + performance.contest_category.name + "\nAltersgruppe " + performance.age_group, at: [0, pdf.bounds.bottom + 2 * pdf.font.height]

    if performance.stage_time.nil?
      stage_time = ""
    else
      stage_time = l performance.stage_time, format: :short
    end
    # Add host of performance's preceding contest if applicable
    if performance.predecessor
      pdf.text_box performance.predecessor.associated_host.name + "\n#{stage_time}", at: [250, pdf.bounds.bottom + 2 * pdf.font.height], align: :right
    else
      pdf.text_box "#{stage_time}", at: [250, pdf.bounds.bottom + pdf.font.height], align: :right
    end

    pdf.stroke do
      pdf.line pdf.bounds.bottom_left, pdf.bounds.bottom_right
    end
  end

  # Participants and pieces

  pdf.bounding_box [50, 650], width: 400, height: 550 do
    pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf"
    performance.appearances.role_order.each do |appearance|
      if appearance.accompaniment?
        pdf.fill_color muted_color
        if appearance.age_group != performance.age_group
          pdf.text appearance.participant.full_name + ", " + appearance.instrument.name + " (AG #{appearance.age_group})"
        else
          pdf.text appearance.participant.full_name + ", " + appearance.instrument.name
        end
      else
        pdf.fill_color default_color
        pdf.text appearance.participant.full_name + ", " + appearance.instrument.name
      end
    end
    pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
    pdf.fill_color default_color
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

  # Point ranges for prizes and predicates

  pdf.bounding_box [50, 50], width: 400, height: 40 do
    pdf.font "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf"
    pdf.font_size = 9
    pdf.fill_color default_color
    index = @contest.round.level - 1
    pdf.text_box JUMU_PRIZE_POINT_RANGES[index]
      .map { |prize, point_range|
        "#{point_range.first}–#{point_range.last} Punkte: #{prize}"
      }
      .join("\n")

    pdf.text_box JUMU_PREDICATE_POINT_RANGES[index]
      .map { |predicate, point_range|
        "#{point_range.first}–#{point_range.last} Punkte: #{predicate}"
      }
      .join("\n"),
      at: [150, pdf.bounds.top]
  end
end
