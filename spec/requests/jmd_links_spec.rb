require 'spec_helper'

describe "JMD Links" do
  
  describe "when signed in" do
    
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :username, :with => @user.username
      fill_in :password, :with => @user.password
      click_button
    end
    
    it "should have an entry management page at /jmd/entries" do
      get '/jmd/entries'
      response.should have_selector('h2', :content => "Wertungen verwalten")
    end
  
    it "should have a link for managing entries in the sidebar" do
      visit root_path
      click_link "Wertungen"
      response.should have_selector('h2', :content => "Wertungen verwalten")
    end
  end
end