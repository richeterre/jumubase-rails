Jmd::Application.routes.draw do
  
  namespace :jmd do
    resources :appearances, :entries, :users, :venues
  end
  
  # Public pages, mostly static
  match '/wettbewerb',    :to => 'pages#competition', :as => :competition
  match '/regeln',        :to => 'pages#rules', :as => :rules
  match '/organisation',  :to => 'pages#organisation', :as => :organisation
  match '/kontakt',       :to => 'contacts#new', :as => :contact
  
  root :to => 'pages#home'
  
  # Legacy paths
  match '/ausschreibung' => redirect('/regeln')
end
