Jmd::Application.routes.draw do
  
  # Routes for internal (JMD) pages
  
  namespace :jmd do
    match 'entries/search', :to => 'entries#search', :as => :entries_search
    resources :appearances, :entries, :users, :venues
  end
  
  # Routes for public pages
  
  resources :contacts, :only => [:new, :create]
  
  # Login & signup edit pages
  match '/vorspiel-bearbeiten', :to => redirect('/jmd/entries/search'),
                                :as => :signup_search
  
  # Public pages, mostly static
  match '/wettbewerb',    :to => 'pages#competition', :as => :competition
  match '/regeln',        :to => 'pages#rules', :as => :rules
  match '/organisation',  :to => 'pages#organisation', :as => :organisation
  match '/kontakt',       :to => 'contacts#new', :as => :contact
  
  root :to => 'pages#home'
  
  # Legacy paths
  match '/ausschreibung' => redirect('/regeln')
end
