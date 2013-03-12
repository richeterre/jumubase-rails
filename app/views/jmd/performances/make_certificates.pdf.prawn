# Define font family
pdf.font_families.update(
   "DejaVuSans" => { bold:        "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf",
                     italic:      "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Oblique.ttf",
                     bold_italic: "#{Rails.root}/vendor/assets/fonts/DejaVuSans-BoldOblique.ttf",
                     normal:      "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf" })

@performances.each do |performance|
  performance.appearances.role_order.each do |appearance|

    pdf.start_new_page(layout: :portrait)
    pdf.font "DejaVuSans"
    pdf.font_size = 10
    pdf.default_leading = 3

    pdf.bounding_box [50, 600], width: 400, height: 200 do
      participants_text = ""
      if appearance.ensemble?
        # For ensembles, print all players
        performance.appearances.role_order.each do |a|
          participants_text << "#{a.participant.full_name}, #{a.instrument.name}\n"
        end
      else
        participants_text << "#{appearance.participant.full_name}, #{appearance.instrument.name}\n"
      end
      pdf.text_box participants_text, valign: :bottom, style: :bold
    end

    pdf.bounding_box [50, 350], width: 400, height: 200 do
      pdf.indent(30) do
        if appearance.ensemble?
          pdf.text "haben am #{performance.competition.round.name} in #{performance.competition.host.city} #{performance.competition.year}"
        else
          pdf.text "hat am #{performance.competition.round.name} in #{performance.competition.host.city} #{performance.competition.year}"
        end

        pdf.text "für das instrumentale und vokale Musizieren der Jugend"

        if appearance.accompaniment?
          pdf.text "in der Wertung für <i>Instrumentalbegleitung<i>", inline_format: true
          pdf.text "in der Kategorie #{performance.category.name} (AG #{performance.age_group})"
        else
          pdf.text "in der Wertung für <i>#{performance.category.name}</i>", inline_format: true
          pdf.text "\n" # Empty row
        end

        pdf.text "in der Altersgruppe <i>#{appearance.age_group}</i>", inline_format: true
        pdf.text appearance.predicate || "teilgenommen"

        if appearance.points && appearance.ensemble?
          pdf.text "und erreichten <i>#{appearance.points} Punkte</i>.",
              inline_format: true
        elsif appearance.points
          pdf.text "und erreichte <i>#{appearance.points} Punkte</i>.",
              inline_format: true
        end
      end

      pdf.move_down(30)

      pdf.text "Zuerkannt wurde ein #{appearance.prize}", style: :bold if appearance.prize
      if appearance.advances_to_next_round?
        pdf.text "mit der Berechtigung zur Teilnahme am #{performance.competition.round.next_round_name}."
      end
    end

    pdf.bounding_box [50, 100], width: 400 do

      pdf.text "#{performance.competition.host.city}, den #{l (performance.competition.certificate_date ?
          performance.competition.certificate_date : performance.competition.ends)}"

      pdf.move_down(60)

      pdf.text_box "Für den #{performance.competition.round.board_name}", at: [0, pdf.bounds.bottom + pdf.font.height]
      pdf.text_box "Für die Jury", at: [300, pdf.bounds.bottom + pdf.font.height]
    end
  end
end
