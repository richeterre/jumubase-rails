require 'spec_helper'

describe "JMD Links" do
  
  describe "when signed in as a non-admin user" do
    
    before(:each) do
      @user = Factory(:user)
      visit signin_path
      fill_in :username, :with => @user.username
      fill_in :password, :with => @user.password
      click_button
    end
    
    it "should not have links for managing users and competitions in the sidebar" do
      visit root_path
      response.should_not have_selector('a', :content => "Benutzer")
      response.should_not have_selector('a', :content => "Wettbewerbe")
    end
    
    it "should redirect to home page when trying to access user management at /jmd/users" do
      get '/jmd/users'
      response.should render_template('pages/home')
    end
    
    it "should redirect to home page when trying to access competition management at /jmd/users" do
      get '/jmd/competitions'
      response.should render_template('pages/home')
    end
    
    it "should give access to an entry management page at /jmd/entries" do
      get '/jmd/entries'
      response.should have_selector('h2', :content => "Wertungen verwalten")
    end
  
    it "should have a link for managing entries in the sidebar" do
      visit root_path
      click_link "Wertungen"
      response.should have_selector('h2', :content => "Wertungen verwalten")
    end
  end
  
  describe "when signed in as an admin user" do
    
    before(:each) do
      @admin = Factory(:admin)
      visit signin_path
      fill_in :username, :with => @admin.username
      fill_in :password, :with => @admin.password
      click_button
    end
    
    it "should have a user management page at /jmd/users" do
      get '/jmd/users'
      response.should have_selector('h2', :content => "Benutzer verwalten")
    end
    
    it "should have a competition management page at /jmd/competitions" do
      get '/jmd/competitions'
      response.should have_selector('h2', :content => "Wettbewerbe verwalten")
    end
    
    it "should have links for managing users and competitions in the sidebar" do
      visit root_path
      click_link "Benutzer"
      response.should have_selector('h2', :content => "Benutzer verwalten")
      click_link "Wettbewerbe"
      response.should have_selector('h2', :content => "Wettbewerbe verwalten")
    end
  end
end