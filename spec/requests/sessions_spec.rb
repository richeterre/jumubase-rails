# encoding: utf-8
require 'spec_helper'

describe "Sessions" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector "h2", text: "Zugang für Organisatoren" }
    it { should have_field "E-Mail", type: :email, text: "" }
    it { should have_field "Passwort", type: :password, text: "" }
    it { should have_button "Anmelden" }
  end

  describe "signin dropdown on home page" do
    before { visit root_path }

    it { should have_selector 'a.dropdown-toggle', text: "Interne Seiten" }
    it { should have_field "E-Mail", type: :email, text: "" }
    it { should have_field "Passwort", type: :password, text: "" }
    it { should have_button "Anmelden" }
  end

  describe "signin via the home page" do
    before { visit root_path }

    describe "with incorrect credentials" do
      before { click_button "Anmelden" }

      it "should not display any inside stuff" do
        page.should_not have_content "Verwalten"
        page.should_not have_content "Vorspiele"
        page.should_not have_content "Eingeben"
        page.should_not have_content "Drucken"
      end

      it { should_not have_link "Abmelden", href: signout_path }
      it { should have_selector "a.dropdown-toggle", text: "Interne Seiten" }

      it "should redirect to the signin page" do
        current_path.should eq signin_path
      end

      it { should have_error_message }
      it { should have_content "Die E-Mailadresse oder das Passwort war falsch." }

      describe "after revisiting the page" do
        before { click_link "Startseite" }

        it { should_not have_error_message }
      end
    end

    describe "with valid credentials" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it "should display some inside stuff" do
        page.should have_content "Verwalten"
        page.should have_content "Vorspiele"
        page.should have_content "Eingeben"
        page.should have_content "Drucken"
      end

      it "should have a link to the user profile"

      it { should have_link "Abmelden", href: signout_path }
      it { should_not have_selector "a.dropdown-toggle", text: "Interne Seiten" }

      describe "followed by signout" do
        before { click_link "Abmelden" }

        it { should have_selector "a.dropdown-toggle", text: "Interne Seiten" }
      end
    end
  end

  describe "inside sidebar" do

    describe "for non-admins" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should_not have_link "Benutzer", href: jmd_users_path }
      it { should have_link "Wertungen", href: jmd_performances_path }
      it { should have_link "Ergebnisse", href: jmd_appearances_path }
    end
  end
end
