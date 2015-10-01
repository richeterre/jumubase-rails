# encoding: utf-8
require 'spec_helper'

describe "Contacts" do

  subject { page }

  before { visit contact_path }

  describe "message form" do
    it "should have all the required form fields" do
      page.should have_selector "h2", text: "Kontakt"
      page.should have_selector "h3", text: "Mitteilung an das Jumu-Team"
      page.should have_field "Name", text: ""
      page.should have_field "E-Mail", type: "email", text: ""
      page.should have_field "Betreff", text: ""
      page.should have_field "Nachricht", text: ""
      page.should have_button "Mitteilung senden"
    end

    describe "when sending a message" do

      describe "with invalid data" do
        before { click_button "Mitteilung senden" }

        it { should have_error_message }
        it { should have_content "Name muss ausgefüllt werden" }
        it { should have_content "E-Mail muss ausgefüllt werden" }
        it { should have_content "E-Mail ist nicht gültig" }
        it { should have_content "Betreff muss ausgefüllt werden" }
        it { should have_content "Nachricht muss ausgefüllt werden" }
      end

      describe "with valid data" do
        before do
          fill_in "Name", with: "John Doe"
          fill_in "contact_email", with: "john.doe@example.org"
          fill_in "Betreff", with: "My Subject"
          fill_in "Nachricht", with: "Lörem ipsüm in adipißicing Duis voluptate et fugiät Excepteur."
          click_button "Mitteilung senden"
        end

        it { should have_success_message }
        it { should have_content "Deine Mitteilung wurde verschickt. Vielen Dank!" }

        it "should stay on the contact page" do
          current_path.should eq "/kontakt"
        end

        it "should send the message correctly as an email" do
          open_last_email.should be_delivered_from "John Doe <john.doe@example.org>"
          open_last_email.should be_delivered_to JUMU_ORGMAILS
          open_last_email.should have_subject "My Subject"
          open_last_email.should have_body_text "Lörem ipsüm in adipißicing Duis voluptate et fugiät Excepteur."
        end
      end
    end
  end
end
