# Define font family
pdf.font_families.update(
   "DejaVuSans" => { bold:        "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Bold.ttf",
                     italic:      "#{Rails.root}/vendor/assets/fonts/DejaVuSans-Oblique.ttf",
                     bold_italic: "#{Rails.root}/vendor/assets/fonts/DejaVuSans-BoldOblique.ttf",
                     normal:      "#{Rails.root}/vendor/assets/fonts/DejaVuSans.ttf" })

@performances.each do |performance|
  performance.appearances.role_order.each do |appearance|

    is_kimu = performance.category.kimu?

    pdf.start_new_page(layout: :portrait)

    pdf.font "DejaVuSans"
    pdf.font_size = 10
    pdf.default_leading = 3

    if is_kimu
      pdf.move_down(245)
      pdf.text "URKUNDE", align: :center, size: 64
    end

    participants_y = is_kimu ? 550 : 600

    pdf.bounding_box [50, participants_y], width: 420, height: 200 do
      participants_text = ""
      if appearance.ensemble?
        # For ensembles, print all ensemblists together
        performance.ensemble_appearances.role_order.each do |a|
          participants_text << "#{a.participant.full_name}, #{a.instrument.name}\n"
        end
      else
        participants_text << "#{appearance.participant.full_name}, #{appearance.instrument.name}\n"
      end
      pdf.text_box participants_text, valign: :bottom, style: :bold
    end

    results_y = is_kimu ? 300 : 350

    pdf.bounding_box [50, results_y], width: 420, height: 200 do
      pdf.indent(30) do
        round_name = name_for_round(performance.contest.round)

        round_text = is_kimu ? "im Rahmen des #{round_name}s" : "am #{round_name}"

        if appearance.ensemble?
          pdf.text "haben #{round_text} in #{performance.contest.host.city} #{performance.contest.year}"
        else
          pdf.text "hat #{round_text} in #{performance.contest.host.city} #{performance.contest.year}"
        end

        pdf.text "für das instrumentale und vokale Musizieren der Jugend"

        if appearance.accompaniment?
          pdf.text "in der Wertung für <i>Instrumentalbegleitung<i>", inline_format: true
          pdf.text "in der Kategorie #{performance.contest_category.name} (AG #{performance.age_group})"
        else
          pdf.text "in der Wertung für <i>#{performance.contest_category.name}</i>", inline_format: true
          pdf.text "\n" # Empty row
        end

        pdf.text "in der Altersgruppe <i>#{appearance.age_group}</i>", inline_format: true

        if is_kimu
          pdf.text "teilgenommen."
        else
          pdf.text appearance.rating || "teilgenommen"
        end

        if !is_kimu
          if appearance.points && appearance.ensemble?
            pdf.text "und erreichten <i>#{appearance.points} Punkte</i>.",
                inline_format: true
          elsif appearance.points
            pdf.text "und erreichte <i>#{appearance.points} Punkte</i>.",
                inline_format: true
          end
        end
      end

      pdf.move_down(30)

      if is_kimu
        pdf.text "Zuerkannt wurde das Prädikat: #{appearance.rating}", style: :bold if appearance.rating
      else
        pdf.text "Zuerkannt wurde ein #{appearance.prize}", style: :bold if appearance.prize
        if appearance.advances_to_next_round? && !appearance.accompaniment?
          pdf.text "mit der Berechtigung zur Teilnahme am #{performance.contest.next_round_name}."
        end
      end
    end

    pdf.bounding_box [50, 100], width: 420 do

      pdf.text "#{performance.contest.host.city}, den #{l (performance.contest.certificate_date ?
          performance.contest.certificate_date : performance.contest.ends)}"

      pdf.move_down(60)

      if is_kimu
        pdf.text_box "Für die Jury", at: [0, pdf.bounds.bottom + pdf.font.height]
      else
        pdf.text_box "Für den #{board_name_for_round(performance.contest.round)}", at: [0, pdf.bounds.bottom + pdf.font.height]
        pdf.text_box "Für die Jury", at: [300, pdf.bounds.bottom + pdf.font.height]
      end
    end
  end
end
