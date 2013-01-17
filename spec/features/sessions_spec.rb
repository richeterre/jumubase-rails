# encoding: utf-8
require 'spec_helper'

describe "Sessions" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector "h2", text: "Zugang für Organisatoren" }
    it { should have_field "E-Mail", type: "email", text: "" }
    it { should have_field "Passwort", type: "password", text: "" }
    it { should have_button "Anmelden" }
  end

  describe "signin dropdown on home page" do
    before { visit root_path }

    it { should have_selector 'a.dropdown-toggle', text: "Interne Seiten" }
    it { should have_field "E-Mail", type: "email", text: "" }
    it { should have_field "Passwort", type: "password", text: "" }
    it { should have_button "Anmelden" }
  end

  describe "signin via the home page" do
    before { visit root_path }

    describe "with incorrect credentials" do
      before { click_button "Anmelden" }

      it "should not display any inside stuff" do
        page.should_not have_selector "li", text: "Verwalten"
        page.should_not have_link "Vorspiele"
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
        page.should have_selector "li", text: "Verwalten"
        page.should have_link "Vorspiele"
      end

      it "should have a link to the user profile"
      it "should display the user's full name in the top bar" do
        page.should have_selector "header a", text: user.full_name
      end

      it { should have_link "Abmelden", href: signout_path }
      it { should_not have_selector "a.dropdown-toggle", text: "Interne Seiten" }

      describe "followed by signout" do
        before { click_link "Abmelden" }

        it { should have_selector "a.dropdown-toggle", text: "Interne Seiten" }
      end
    end
  end

  describe "requesting a page restricted to signed-in users" do
    before { visit jmd_performances_path }

    it "should ask the user to sign in first" do
      current_path.should eq signin_path
      page.should have_alert_message
      page.should have_content "Bitte melde dich mit ausreichenden Rechten an, um diese Seite zu besuchen."
    end

    it "should present a signin form" do

    end

    it "should redirect to the requested page after signing in through the form" do
      user = FactoryGirl.create(:user)
      fill_in "session_email", with: user.email
      fill_in "session_password", with: user.password
      click_button "session_submit"

      current_path.should eq jmd_performances_path
      page.should have_info_message
      page.should have_content "Willkommen, #{user.full_name}! Du bist jetzt angemeldet."
    end

    it "should redirect to the requested page after signing in through the dropdown" do
      user = FactoryGirl.create(:user)
      sign_in(user)

      current_path.should eq jmd_performances_path
      page.should have_info_message
      page.should have_content "Willkommen, #{user.full_name}! Du bist jetzt angemeldet."
    end
  end

  describe "requesting a page restricted to admins" do
    before { visit jmd_users_path }

    it "should ask the user to sign in first" do
      current_path.should eq signin_path
      page.should have_alert_message
      page.should have_content "Bitte melde dich mit ausreichenden Rechten an, um diese Seite zu besuchen."
    end

    context "as a non-admin user" do

      it "should ask the user to sign in with sufficient rights" do
        user = FactoryGirl.create(:user)
        sign_in(user)

        current_path.should eq signin_path
        page.should have_alert_message
        page.should have_content "Bitte melde dich mit ausreichenden Rechten an, um diese Seite zu besuchen."
      end
    end

    context "as an admin user" do

      it "should give access to the page" do
        admin = FactoryGirl.create(:admin)
        sign_in(admin)

        current_path.should eq jmd_users_path
        page.should have_info_message
        page.should have_content "Willkommen, #{admin.full_name}! Du bist jetzt angemeldet."
      end
    end
  end

  describe "inside sidebar" do
    before { visit root_path }

    describe "for non-admins" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should_not have_link "Benutzer", href: jmd_users_path }
      it { should_not have_link "Wettbewerbe", href: jmd_competitions_path }
      it { should have_link "Vorspiele", href: jmd_performances_path }
      it { should have_link "Ergebnisse", href: jmd_appearances_path }
      it { should have_link "Urkunden", href: make_certificates_jmd_performances_path }
    end

    describe "for admins" do
      let(:admin) { FactoryGirl.create(:admin) }
      before { sign_in admin }

      it { should have_link "Benutzer", href: jmd_users_path }
      it { should have_link "Wettbewerbe", href: jmd_competitions_path }
      it { should have_link "Weiterleitungen", href: list_advancing_jmd_performances_path }
    end
  end
end
