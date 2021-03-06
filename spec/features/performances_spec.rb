# encoding: utf-8
require 'spec_helper'

describe "Performances" do

  subject { page }

  describe "signup page" do

    before do
      create_list(:past_contest, 3)
      create_list(:future_contest, 3)
      @current_contest = create(:current_contest)
      @deadlined_contest = create(:deadlined_contest)

      create_list(:contest_category, 3)
      @contest_categories = create_list(:contest_category, 3, contest: @current_contest)

      create_list(:instrument, 3)

      visit new_contest_performance_path(@current_contest)
    end

    it "should have all the required content and fields" do
      page.should have_selector "h2", text: "Anmeldung zum #{JUMU_SEASON}. Wettbewerb \"Jugend musiziert\""
      page.should have_select "Wettbewerb", options: ["Bitte wählen"] + @current_contests.map(&:name)
      page.should have_selector ".help-block", text: "Dein Wettbewerb steht hier bis zum Anmeldeschluss (siehe oben)."
      page.should have_select "Kategorie", options: ["Bitte wählen"] + @contest_categories.map(&:name)
      page.should have_field "Vorname", text: ""
      page.should have_field "Nachname", text: ""
      page.should have_select "Rolle", options: ["Bitte wählen"] + Role.all.map(&:name)
      page.should have_select "Instrument", options: ["Bitte wählen"] + Instrument.all.map(&:name)
      page.should have_select "Geburtsdatum"
      page.should have_field "männlich"
      page.should have_field "weiblich"
      page.should have_field "Straße", text: ""
      page.should have_field "Postleitzahl", text: ""
      page.should have_field "Ort", text: ""
      page.should have_select "Land", options: ["Bitte wählen"] + Country.all.map(&:name)
      page.should have_field "Telefon", text: ""
      page.should have_field "E-Mail", type: "email", text: ""
      page.should have_button "Teilnehmer entfernen"
      page.should have_button "Weiteren Teilnehmer hinzufügen"
      page.should have_field "Titel", text: ""
      page.should have_field "Komponist", text: ""
      page.should have_field "Geburtsjahr", text: ""
      page.should have_field "(Todesjahr)", text: ""
      page.should have_select "Epoche", options: ["Bitte wählen"] + Epoch.all.map(&:slug_with_name)
      page.should have_field "Dauer ca.", type: "text", text: "" # Minutes field
      page.should have_field "performance_pieces_attributes_0_seconds", type: "text", text: "" # Seconds field
      page.should have_button "Stück entfernen"
      page.should have_button "Weiteres Stück hinzufügen"
      page.should have_button "Anmeldung absenden"
    end

    it "should not have deadlined contests in the select box" do
      page.should_not have_select "Wettbewerb", with_options: [@deadlined_contest.name]
    end

    it "should complain about invalid field contents" do
      click_button "Anmeldung absenden"

      page.should have_error_message
      page.should have_content "Vorname des Teilnehmers muss ausgefüllt werden"
      page.should have_content "Nachname des Teilnehmers muss ausgefüllt werden"
      page.should have_content "Geschlecht des Teilnehmers muss ausgefüllt werden"
      page.should have_content "Geschlecht des Teilnehmers ist kein gültiger Wert"
      page.should have_content "Geburtsdatum des Teilnehmers muss ausgefüllt werden"
      page.should have_content "Land des Teilnehmers muss ausgefüllt werden"
      page.should have_content "Telefonnummer des Teilnehmers muss ausgefüllt werden"
      page.should have_content "E-Mail des Teilnehmers muss ausgefüllt werden"
      page.should have_content "E-Mail des Teilnehmers ist nicht gültig"
      page.should have_content "Instrument des Teilnehmers muss ausgefüllt werden"
      page.should have_content "Rolle des Teilnehmers muss ausgefüllt werden"
      page.should have_content "Name des Komponisten muss ausgefüllt werden"
      page.should have_content "Titel des Stücks muss ausgefüllt werden"
      page.should have_content "Epoche des Stücks muss ausgefüllt werden"
      page.should have_content "Dauer (Minuten) des Stücks muss ausgefüllt werden"
      page.should have_content "Dauer (Minuten) des Stücks ist keine Zahl"
      page.should have_content "Dauer (Sekunden) des Stücks muss ausgefüllt werden"
      page.should have_content "Dauer (Sekunden) des Stücks ist keine Zahl"
      page.should have_content "Kategorie muss ausgefüllt werden"
      page.should have_content "Wettbewerb muss ausgefüllt werden"
    end

    it "should correctly populate the contest selector when there are errors" do
      click_button "Anmeldung absenden"
      page.should have_select "Wettbewerb", options: ["Bitte wählen"] + @current_contests.map(&:name)
    end

    it "should complain about disabled JavaScript", js: false do
      page.should have_alert_message
      page.should have_content "Achtung: JavaScript ist in deinem Browser nicht aktiviert!"
      page.should have_content "Damit die Seite richtig funktioniert, musst du es zunächst einschalten. Wie das gemacht wird, steht z.B. hier."
    end

    it "should allow adding new participants to the form", js: true do
      click_button "Weiteren Teilnehmer hinzufügen"
      page.should have_selector "h3", text: "Teilnehmer 2"
    end

    it "should allow adding new pieces to the form", js: true do
      click_button "Weiteres Stück hinzufügen"
      page.should have_selector "h3", text: "Stück 2"
    end

    it "should complain if no participants are provided", js: true do
      click_button "Teilnehmer entfernen"
      click_button "Anmeldung absenden"
      page.should have_content "Es muss mindestens ein Teilnehmer angegeben werden"
    end

    it "should complain if no pieces are provided", js: true do
      click_button "Stück entfernen"
      click_button "Anmeldung absenden"
      page.should have_content "Es muss mindestens ein Stück angegeben werden"
    end

    # This is currently enforced through a db index, but causes the app to go 500
    it "should complain if a participant is contained twice in the form"

    it "should mention the min/max values for minutes and seconds in the error message" do
      fill_in "performance_pieces_attributes_0_minutes", with: "60"
      fill_in "performance_pieces_attributes_0_seconds", with: "60"
      click_button "Anmeldung absenden"

      page.should have_content "Dauer (Minuten) des Stücks muss kleiner als 60 sein"
      page.should have_content "Dauer (Sekunden) des Stücks muss kleiner als 60 sein"

      fill_in "performance_pieces_attributes_0_minutes", with: "-1"
      fill_in "performance_pieces_attributes_0_seconds", with: "-1"
      click_button "Anmeldung absenden"

      page.should have_content "Dauer (Minuten) des Stücks muss größer oder gleich 0 sein"
      page.should have_content "Dauer (Sekunden) des Stücks muss größer oder gleich 0 sein"
    end

    it "should perform the signup when given valid data" do
      expect {
        select @current_contests.first.name, from: "Wettbewerb"
        select @contest_categories.first.name, from: "Kategorie"

        fill_in "Vorname", with: "John"
        fill_in "Nachname", with: "Doe"
        select Role.first.name, from: "Rolle"
        select Instrument.first.name, from: "Instrument"
        select_date "Geburtsdatum", with: Date.today - 15.years
        choose "männlich"
        fill_in "Straße", with: "Example Street 123"
        fill_in "Postleitzahl", with: "12345"
        fill_in "Ort", with: "Exampletown"
        select Country.first.name, from: "Land"
        fill_in "Telefon", with: "123456789"
        fill_in "performance_appearances_attributes_0_participant_attributes_email", with: "john.doe@example.org"

        fill_in "Titel", with: "Example Piece"
        fill_in "Komponist", with: "Example Composer"
        fill_in "Geburtsjahr", with: "1850"
        fill_in "(Todesjahr)", with: "1950"
        select Epoch.first.slug_with_name, from: "Epoche"
        fill_in "performance_pieces_attributes_0_minutes", with: 4
        fill_in "performance_pieces_attributes_0_seconds", with: 33

        click_button "Anmeldung absenden"

      }.to change(Performance, :count).by(1)

      open_last_email.should be_delivered_from "anmeldung@jumu-nordost.eu"
      open_last_email.should be_delivered_to "John Doe <john.doe@example.org>"
      open_last_email.should have_subject "Jumu-Anmeldung in der Kategorie \"#{@contest_categories.first.name}\""
      open_last_email.should have_body_text "Anmeldeschluss am #{I18n.l(Date.today, format: :long)}"
      open_last_email.should have_body_text Performance.last.tracing_code
      open_last_email.should have_body_text signup_search_url(host: "www.jumu-nordost.eu")
    end

    it "should allow only birthdays in a certain range"
  end

  describe "edit page" do

    before { @performance = create(:current_performance) }

    it "should find and display an existing performance based on its tracing code" do
      search_for_performance_with_code(@performance.tracing_code)

      page.should have_selector "h2", text: "Anmeldung bearbeiten"
      page.should have_select 'Wettbewerb', selected: @performance.contest.name
      page.should have_selector ".help-block", text: "Dein Wettbewerb steht hier bis zum Anmeldeschluss (siehe oben)."
      page.should have_select 'Kategorie', selected: @performance.category.name

      page.should have_selector 'div.appearance', count: @performance.appearances.count
      page.should have_field "Vorname", with: @performance.participants.first.first_name
      page.should have_field "Nachname", with: @performance.participants.first.last_name
      page.should have_select "Rolle", selected: @performance.appearances.first.role.name
      page.should have_select "Instrument", selected: @performance.appearances.first.instrument.name

      page.should have_select "performance_appearances_attributes_0_participant_attributes_birthdate_1i",
                              selected: @performance.participants.first.birthdate.year.to_s
      page.should have_select "performance_appearances_attributes_0_participant_attributes_birthdate_2i",
                              selected: I18n.t('date.month_names')[ @performance.participants.first.birthdate.month]
      page.should have_select "performance_appearances_attributes_0_participant_attributes_birthdate_3i",
                              selected: @performance.participants.first.birthdate.day.to_s
      page.should have_checked_field "weiblich"
      page.should have_field "Straße", with: @performance.participants.first.street
      page.should have_field "Postleitzahl", with: @performance.participants.first.postal_code
      page.should have_select "Land", selected: @performance.participants.first.country.name
      page.should have_field "Telefon", with: @performance.participants.first.phone
      page.should have_field "E-Mail", with: @performance.participants.first.email

      page.should have_selector 'div.piece', count: @performance.pieces.count
      page.should have_field "Titel", with: @performance.pieces.first.title
      page.should have_field "Komponist", with: @performance.pieces.first.composer.name
      page.should have_field "Geburtsjahr", with: @performance.pieces.first.composer.born
      page.should have_field "(Todesjahr)", with: @performance.pieces.first.composer.died
      page.should have_select "Epoche", selected: @performance.pieces.first.epoch.slug_with_name
      page.should have_field "Dauer ca.", type: "text", with: @performance.pieces.first.minutes.to_s
      page.should have_field "performance_pieces_attributes_0_seconds",
                             type: "text", with: @performance.pieces.first.seconds.to_s

      page.should have_button "Änderungen speichern"
    end

    it "should allow editing of an existing performance" do
      search_for_performance_with_code(@performance.tracing_code)
      fill_in "Vorname", with: "Jeanette"
      choose "weiblich"
      click_button "Änderungen speichern"

      page.should have_selector "h2", text: "Nach Anmeldung suchen"
      page.should have_success_message
      page.should have_content "Die Anmeldung wurde erfolgreich aktualisiert."

      search_for_performance_with_code(@performance.tracing_code)

      page.should have_field "Vorname", with: "Jeanette"
      page.should have_checked_field "weiblich"
    end

    # See http://blog.leshill.org/blog/2010/04/20/validating-presence-with-nested-models.html
    it "should not allow the user to delete all appearances", js: true do
      search_for_performance_with_code(@performance.tracing_code)

      click_button "Teilnehmer entfernen"
      click_button "Änderungen speichern"

      page.should have_error_message
      page.should have_content "Es muss mindestens ein Teilnehmer angegeben werden"
    end

    it "should not allow the user to delete all pieces", js: true do
      search_for_performance_with_code(@performance.tracing_code)

      click_button "Stück entfernen"
      click_button "Änderungen speichern"

      page.should have_error_message
      page.should have_content "Es muss mindestens ein Stück angegeben werden"
    end

    it "should complain about an incorrect tracing code" do
      search_for_performance_with_code("abc1234")

      page.should have_error_message
      page.should have_content "Keine Anmeldung unter diesem Änderungscode gefunden."
    end

    it "should complain about a missing tracing code" do
      search_for_performance_with_code("")

      page.should have_error_message
      page.should have_content "Bitte gib den Änderungscode für die gesuchte Anmeldung an."
    end

    it "should not find a non-current performance" do
      old_performance = create(:old_performance)
      search_for_performance_with_code(old_performance.tracing_code)

      page.should have_error_message
      page.should have_content "Keine Anmeldung unter diesem Änderungscode gefunden."
    end

    it "should not allow editing a performance for a deadlined contest" do
      deadlined_contest = create(:deadlined_contest)
      deadlined_performance = create(:performance,
        contest_category: create(:contest_category, contest: deadlined_contest)
      )

      search_for_performance_with_code(deadlined_performance.tracing_code)

      page.should have_error_message
      page.should have_content "Der Anmeldeschluss für deinen Wettbewerb war bereits am "\
                               "#{I18n.l(deadlined_contest.last_signup_date, format: :long)}. "\
                               "Bitte nimm Kontakt zu einem Jumu-Ansprechpartner an deiner Schule auf."
    end

    # Use this in controller: unless admin? || @performance[:tracing_code] == params[:tracing_code]
    # it "should grant access to logged-in admins even without a tracing code"
    # or then not? Admins can edit entries in JMD after all
  end

  describe "JMD" do

    before do
      @host = create(:host)
      @current_contest = create(:current_contest, host: @host)
      @current_performance = create(:performance,
        contest_category: create(:contest_category, contest: @current_contest)
      )
      past_contest = create(:past_contest, host: @host)
      @past_performance = create(:performance,
        contest_category: create(:contest_category, contest: past_contest)
      )

      other_host = create(:host)
      other_current_contest = create(:current_contest, host: other_host)
      @other_performance = create(:performance,
        contest_category: create(:contest_category, contest: other_current_contest)
      )
    end

    let(:user) { create(:user, hosts: [@host]) }
    let(:admin) { create(:admin) }

    describe "index page" do

      context "when signed in as a regular user" do
        before do
          visit root_path
          sign_in(user)
          visit jmd_contest_performances_path(@current_contest)
        end

        it "should list current performances from own hosts' contests" do
          page.should have_selector "tbody tr > td", text: @current_performance.participants.first.full_name
        end

        it "should not list non-current performances from own hosts' contests" do
          page.should_not have_selector "tbody tr > td", text: @past_performance.participants.first.full_name
        end

        it "should not list current performances from other hosts' contests" do
          page.should_not have_selector "tbody tr > td", text: @other_performance.participants.first.full_name
        end

        describe "for performances that were edited" do

          it "should display an info label"

          it "should state how long ago they were edited"
        end

        it "should allow the user to delete a performance"

        it "should have a link to an internal performance creation form" do
          click_link "Neues Vorspiel erstellen"

          current_path.should eq new_jmd_contest_performance_path(@current_contest)
        end

        describe "pagination" do

          before do
            contest_category = create(:contest_category, contest: @current_contest)
            @current_performances = [@current_performance]
            @current_performances += create_list(:current_performance, 15, contest_category: contest_category)
            visit current_path
          end

          context "with more than 15 performances" do
            it "should display the counts of the paginated list" do
              page.should have_content "Vorspiele 1 – 15 von insgesamt 16"
            end

            it "should display the paginator" do
              page.should have_selector "div.pagination"
              page.should have_link "2", href: jmd_contest_performances_path(@current_contest, page: 2)
              page.should have_link "→", href: jmd_contest_performances_path(@current_contest, page: 2)
            end

            it "should allow paginating between performances" do
              @current_performances[1..15].each do |performance| # Newest first
                page.should have_selector "tbody tr > td",
                                          text: "#{performance.appearances.first.participant.full_name}, #{performance.appearances.first.instrument.name}"
              end

              first(:css, "li.next_page a").click # Proceed to next page

              performance = @current_performances[0] # Second page has the one remaining performance
              page.should have_selector "tbody tr > td",
                                        text: "#{performance.appearances.first.participant.full_name}, #{performance.appearances.first.instrument.name}"
            end
          end

          context "with exactly 15 performances" do
            describe "should display the total performance count" do
              before do
                @current_performances.last.destroy
                visit current_path
              end

              it { should have_content "Alle 15 Vorspiele" }
              it { should_not have_selector "div.pagination" }
            end
          end
        end
      end

      context "when signed in as an admin" do
        before do
          visit root_path
          sign_in(admin)
          visit jmd_contest_performances_path(@current_contest)
        end

        it "should have all current performances in the table" do
          page.should have_content "Alle 2 Vorspiele"

          Performance.current.each do |performance| # Newest first
            page.should have_selector "tbody tr > td",
                                      text: "#{performance.appearances.first.participant.full_name}, #{performance.appearances.first.instrument.name}"
          end
        end
      end
    end

    describe "create page" do
      before do
        # TODO: Create some contests, current and other, here for different users
      end

      context "for non-admins" do
        before do
          visit root_path
          sign_in(user)
          visit new_jmd_contest_performance_path(@current_contest)
        end

        it "should only offer own contests to add the performance to" do
          page.should have_select "Wettbewerb", options: ["Bitte wählen", @current_contest.name]
        end

        it "should not display a hint for the contest selector" do
          page.should_not have_selector ".help-block", text: I18n.t('simple_form.hints.performance.contest_id')
        end
      end

      context "for admins" do
        before do
          visit root_path
          sign_in(admin)
          visit new_jmd_contest_performance_path(@current_contest)
        end

        it "should offer all current contests" do
          page.should have_select "Wettbewerb", options: ["Bitte wählen"] + Contest.current.map(&:name)
        end
      end
    end

    describe "edit page" do
      it "should not display a hint for the contest selector" do
        page.should_not have_selector ".help-block", text: I18n.t('simple_form.hints.performance.contest_id')
      end

      it "should allow returning to the index page without saving anything"
    end

    describe "show page" do
      before do
        visit root_path
        sign_in(user)
        visit jmd_performance_path(@current_performance)
      end

      it "should list all participants in the performance" do
        @current_performance.participants.each do |participant|
          page.should have_selector "a.modal-link", text: participant.full_name
        end
      end

      it "should open a modal window with contact info when clicking a participant's name"
    end

    describe "certificate page" do
      before do
        visit root_path
        sign_in(user)
      end

      it "should list all performances with their appearances"

      describe "contest filter" do

        it "should display only performances from the selected contest"

      end

      describe "category filter" do

        before do
          @second_performance = create(:current_performance,
            contest_category: create(:contest_category, contest: @current_contest)
          )
          visit make_certificates_jmd_performances_path

          # Apply filter
          select @current_performance.category.name, from: "_in_category"
          click_on "Filtern"
        end

        it "should display only performances in the selected category" do
          page.should have_selector "tbody tr", count: 1
          @current_performance.appearances.each do |appearance|
            page.should have_selector "tbody tr",
                                      text: "#{@current_performance.category.name}" + " " +
                                            "#{appearance.participant.full_name}, #{appearance.instrument.name}"
          end
        end

        it "should allow the user to clear the filters" do
          click_on "Alle anzeigen"
          page.should have_selector "tbody tr", count: 2
          @current_performance.appearances.each do |appearance|
            page.should have_selector "tbody tr",
                                      text: "#{@current_performance.category.name}" + " " +
                                            "#{appearance.participant.full_name}, #{appearance.instrument.name}"
          end
          @second_performance.appearances.each do |appearance|
            page.should have_selector "tbody tr",
                                      text: "#{@second_performance.category.name}" + " " +
                                            "#{appearance.participant.full_name}, #{appearance.instrument.name}"
          end
        end
      end
    end
  end
end
