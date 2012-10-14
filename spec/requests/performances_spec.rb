# encoding: utf-8
require 'spec_helper'

describe "Performances" do

  subject { page }

  describe "signup page" do

    describe "for the first round" do

      before do
        FactoryGirl.create_list(:old_competition, 3)
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

      it "should have all the required fields" do
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
          fill_in "E-Mail", with: "john.doe@example.org"

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
        open_last_email.should have_subject "JuMu-Anmeldung in der Kategorie \"#{@active_categories.first.name}\""
      end

      it "should allow only birthdays in a certain range"
    end

    describe "for the second round" do

      it "should pre-select the competition for the user"

      it "should already know where the first round was performed" do
        pending "Or even better, don't require this form at all"
      end
    end
  end

  describe "edit page" do

    # See http://blog.leshill.org/blog/2010/04/20/validating-presence-with-nested-models.html
    it "should not allow the user to delete all appearances"
    it "should not allow the user to delete all pieces"

    # Use this in controller: unless admin? || @performance[:tracing_code] == params[:tracing_code]
    it "should grant access to logged-in admins even without a tracing code"
  end
end
