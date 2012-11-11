# encoding: utf-8
require 'spec_helper'

describe "Performances" do

  subject { page }

  describe "signup page" do

    before do
      FactoryGirl.create_list(:past_competition, 3)
      FactoryGirl.create_list(:future_competition, 3)
      @current_competitions = FactoryGirl.create_list(:current_competition, 3)

      FactoryGirl.create_list(:category, 3)
      @active_categories = FactoryGirl.create_list(:active_category, 3)

      FactoryGirl.create(:role)
      FactoryGirl.create(:accompanist_role)
      FactoryGirl.create(:ensemblist_role)
      FactoryGirl.create_list(:instrument, 3)
      FactoryGirl.create_list(:country, 3)
      FactoryGirl.create_list(:epoch, 3)

      visit new_performance_path
    end

    it "should have all the required content and fields" do
      page.should have_selector "h2", text: "Anmeldung zum #{JUMU_SEASON}. Wettbewerb \"Jugend musiziert\""
      page.should have_select "Wettbewerb", options: ["Bitte wählen"] + @current_competitions.map(&:name)
      page.should have_select "Kategorie", options: ["Bitte wählen"] + @active_categories.map(&:name)
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
      page.should have_field "E-Mail", type: :email, text: ""
      page.should have_button "Teilnehmer entfernen"
      page.should have_button "Weiteren Teilnehmer hinzufügen"
      page.should have_field "Titel", text: ""
      page.should have_field "Komponist", text: ""
      page.should have_field "Geburtsjahr", text: ""
      page.should have_field "(Todesjahr)", text: ""
      page.should have_select "Epoche", options: ["Bitte wählen"] + Epoch.all.map(&:slug_with_name)
      page.should have_field "Dauer ca.", type: :number, text: ""
      page.should have_field "", type: :number, text: ""
      page.should have_button "Stück entfernen"
      page.should have_button "Weiteres Stück hinzufügen"
      page.should have_button "Anmeldung absenden"
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
      page.should have_content "Dauer (Minuten) des Stücks ist kein gültiger Wert"
      page.should have_content "Dauer (Sekunden) des Stücks muss ausgefüllt werden"
      page.should have_content "Dauer (Sekunden) des Stücks ist keine Zahl"
      page.should have_content "Kategorie muss ausgefüllt werden"
      page.should have_content "Wettbewerb muss ausgefüllt werden"
    end

    it "should complain about disabled JavaScript", js: false do
      page.should have_alert_message
      page.should have_content "Achtung: JavaScript ist in deinem Browser nicht aktiviert!"
      page.should have_content "Damit die Seite richtig funktioniert, musst du es zunächst einschalten. Wie das gemacht wird, steht z.B. hier."
    end

    it "should allow adding new participants to the form", js: true do
      click_button "Weiteren Teilnehmer hinzufügen"
      page.should have_content "Teilnehmer 2"
    end

    it "should allow adding new pieces to the form", js: true do
      click_button "Weiteres Stück hinzufügen"
      page.should have_content "Stück 2"
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

    it "should perform the signup when given valid data" do
      expect {
        select @current_competitions.first.name, from: "Wettbewerb"
        select @active_categories.first.name, from: "Kategorie"

        fill_in "Vorname", with: "John"
        fill_in "Nachname", with: "Doe"
        select Role.first.name, from: "Rolle"
        select Instrument.first.name, from: "Instrument"
        select_date Date.today - 15.years, from: "performance_appearances_attributes_0_participant_attributes_birthdate"
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
        select Epoch.first.name, from: "Epoche"
        fill_in "performance_pieces_attributes_0_minutes", with: 4
        fill_in "performance_pieces_attributes_0_seconds", with: 33

        click_button "Anmeldung absenden"
      }.to change(Performance, :count).by(1)

      open_last_email.should be_delivered_from "anmeldung@jumu-nordost.eu"
      open_last_email.should be_delivered_to "John Doe <john.doe@example.org>"
      open_last_email.should have_subject "JuMu-Anmeldung in der Kategorie \"#{@active_categories.first.name}\""
      open_last_email.should have_body_text Performance.last.tracing_code
      open_last_email.should have_body_text signup_search_url(host: "www.jumu-nordost.eu")
    end

    it "should allow only birthdays in a certain range"
  end

  describe "edit page" do

    before { @performance = FactoryGirl.create(:current_performance) }

    it "should find and display an existing performance based on its tracing code" do
      search_for_performance_with_code(@performance.tracing_code)

      page.should have_selector "h2", text: "Anmeldung bearbeiten"
      page.should have_select 'Wettbewerb', selected: @performance.competition.name
      page.should have_select 'Kategorie', selected: @performance.category.name

      page.should have_selector 'div.appearance', count: @performance.appearances.count
      page.should have_field "Vorname", text: @performance.participants.first.first_name
      page.should have_field "Nachname", text: @performance.participants.first.last_name
      page.should have_select "Rolle", selected: @performance.appearances.first.role.name
      page.should have_select "Instrument", selected: @performance.appearances.first.instrument.name

      page.should have_select "performance_appearances_attributes_0_participant_attributes_birthdate_1i",
                              selected: @performance.participants.first.birthdate.year.to_s
      page.should have_select "performance_appearances_attributes_0_participant_attributes_birthdate_2i",
                              selected: I18n.t("date.month_names")[ @performance.participants.first.birthdate.month]
      page.should have_select "performance_appearances_attributes_0_participant_attributes_birthdate_3i",
                              selected: @performance.participants.first.birthdate.day.to_s
      page.should have_checked_field "weiblich"
      page.should have_field "Straße", text: @performance.participants.first.street
      page.should have_field "Postleitzahl", text: @performance.participants.first.postal_code
      page.should have_select "Land", text: @performance.participants.first.country.name
      page.should have_field "Telefon", text: @performance.participants.first.phone
      page.should have_field "E-Mail", text: @performance.participants.first.email

      page.should have_selector 'div.piece', count: @performance.pieces.count
      page.should have_field "Titel", text: @performance.pieces.first.title
      page.should have_field "Komponist", text: @performance.pieces.first.composer.name
      page.should have_field "Geburtsjahr", text: @performance.pieces.first.composer.born
      page.should have_field "(Todesjahr)", text: @performance.pieces.first.composer.died
      page.should have_select "Epoche", selected: @performance.pieces.first.epoch.slug_with_name
      page.should have_field "Dauer ca.", type: :number, text: @performance.pieces.first.minutes
      page.should have_field "", type: :number, text: @performance.pieces.first.seconds

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

      page.should have_field "Vorname", text: "Jeanette"
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
      old_performance = FactoryGirl.create(:old_performance)
      search_for_performance_with_code(old_performance.tracing_code)

      page.should have_error_message
      page.should have_content "Keine Anmeldung unter diesem Änderungscode gefunden."
    end

    # Use this in controller: unless admin? || @performance[:tracing_code] == params[:tracing_code]
    # it "should grant access to logged-in admins even without a tracing code"
    # or then not? Admins can edit entries in JMD after all
  end

  describe "JMD" do

    before do
      @host = FactoryGirl.create(:host)
      @current_competition = FactoryGirl.create(:current_competition, host: @host)
      @current_performances = FactoryGirl.create_list(:performance, 3, competition: @current_competition)
      past_competition = FactoryGirl.create(:past_competition, host: @host)
      @past_performances = FactoryGirl.create_list(:performance, 3, competition: past_competition)

      other_host = FactoryGirl.create(:host)
      other_current_competition = FactoryGirl.create(:competition, host: other_host)
      @other_performances = FactoryGirl.create_list(:performance, 3, competition: other_current_competition)
    end

    let(:user) { FactoryGirl.create(:user, hosts: [@host]) }
    let(:admin) { FactoryGirl.create(:admin) }

    describe "index page" do

      context "when signed in as a regular user" do
        before do
          visit root_path
          sign_in(user)
          visit jmd_performances_path
        end

        it "should list current performances from own hosts' competitions" do
          @current_performances.each do |performance|
            page.should have_selector "tbody tr > td", text: performance.participants.first.full_name
          end
        end

        it "should not list non-current performances from own hosts' competitions" do
          @past_performances.each do |performance|
            page.should_not have_selector "tbody tr > td", text: performance.participants.first.full_name
          end
        end

        it "should not list current performances from other hosts' competitions" do
          @other_performances.each do |performance|
            page.should_not have_selector "tbody tr > td", text: performance.participants.first.full_name
          end
        end

        describe "for performances that were edited" do

          it "should display an info label"

          it "should state how long ago they were edited"
        end

        it "should allow the user to delete a performance"

        it "should have a link to an internal performance creation form" do
          click_link "Neues Vorspiel erstellen"

          current_path.should eq new_jmd_performance_path
        end
      end

      context "when signed in as an admin" do
        before do
          visit root_path
          sign_in(admin)
          visit jmd_performances_path
        end

        it "should have all current performances in the table" do
          Performance.current.each do |performance|
            page.should have_selector "tbody tr > td", text: performance.participants.first.full_name
          end
        end
      end
    end

    describe "create page" do
      before do
        # TODO: Create some competitions, current and other, here for different users
      end

      context "for non-admins" do
        before do
          visit root_path
          sign_in(user)
          visit new_jmd_performance_path
        end

        it "should only offer own competitions to add the performance to" do
          page.should have_select "Wettbewerb", options: ["Bitte wählen", @current_competition.name]
        end
      end

      context "for admins" do
        before do
          visit root_path
          sign_in(admin)
          visit new_jmd_performance_path
        end

        it "should offer all current competitions" do
          page.should have_select "Wettbewerb", options: ["Bitte wählen"] + Competition.current.map(&:name)
        end
      end
    end

    describe "edit page" do
      it "should allow returning to the index page without saving anything" do

      end
    end
  end
end
