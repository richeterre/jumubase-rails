# encoding: utf-8
require 'spec_helper'

describe "Signup page" do

  subject { page }

  describe "for the first round" do

    before do
      FactoryGirl.create_list(:old_competition, 3)
      FactoryGirl.create_list(:future_competition, 3)
      @current_competitions = FactoryGirl.create_list(:current_competition, 3)

      FactoryGirl.create_list(:category, 3)
      @active_categories = FactoryGirl.create_list(:active_category, 3)

      visit new_performance_path
    end

    it { should have_select "Wettbewerb", options: ["Bitte wählen"] + @current_competitions.map(&:name) }
    it { should have_select "Kategorie", options: ["Bitte wählen"] + @active_categories.map(&:name) }
    it { should have_field "Vorname", text: "" }
    it { should have_field "Nachname", text: "" }
    it { should have_select "Rolle", options: ["Bitte wählen"] + Role.all.map(&:name) }
    it { should have_select "Instrument", options: ["Bitte wählen"] + Instrument.all.map(&:name) }
    it { should have_select "Geburtsdatum" }
    # it { should have_field "Geschlecht" }
    it { should have_field "Straße", text: "" }
    it { should have_field "Postleitzahl", text: "" }
    it { should have_field "Ort", text: "" }
    it { should have_select "Land", options: ["Bitte wählen"] + Country.all.map(&:name) }
    it { should have_field "Telefon", text: "" }
    it { should have_field "E-Mail", type: :email, text: "" }
    it { should have_button "Teilnehmer entfernen" }
    it { should have_button "Weiteren Teilnehmer hinzufügen" }
    it { should have_field "Titel", text: "" }
    it { should have_field "Komponist", text: "" }
    it { should have_field "Geburtsjahr", text: "" }
    it { should have_field "(Todesjahr)", text: "" }
    it { should have_select "Epoche", options: ["Bitte wählen"] + Epoch.all.map(&:name) }
    it { should have_field "Dauer ca.", type: :number, text: "" }
    it { should have_field "", type: :number, text: "" }
    it { should have_button "Stück entfernen" }
    it { should have_button "Weiteres Stück hinzufügen" }
    it { should have_button "Anmeldung absenden" }

    it "should allow only valid inputs for the minutes and seconds fields"
  end

  describe "for the second round" do

    it "should pre-select the competition for the user"

    it "should already know where the first round was performed" do
      pending "Or even better, don't require this form at all"
    end
  end
end