Jmd::Application.routes.draw do

  # Routes for internal (JMD) pages
  
  namespace :jmd do
    resources :appearances, :competitions, :users, :venues
    resources :entries, except: [:new, :create] do
      get 'browse', on: :collection
      get 'schedule_classical', on: :collection
      get 'schedule_pop', on: :collection
      put 'retime', on: :collection
      get 'make_certificates', on: :collection
      get 'make_jury_sheets', on: :collection
    end
  end
  
  
  # Routes for public pages
  
  resources :contacts, :only => [:new, :create]
  resources :sessions, :only => [:create, :destroy]
  
  # Routes for venue timetables
  if JUMU_TIMETABLES_PUBLIC
    match 'venues/:venue_id/timetable(/:year-:month-:day)', to: 'venues#timetable', as: :timetable
  end
  
  # Routes for signup and entry editing, if currently possible
  if JUMU_SIGNUP_OPEN
    resources :entries, :except => [:index, :show, :destroy]
    match '/vorspiel-bearbeiten', :to => 'entries#search', :as => :signup_search
  end
  
  # User session routes
  match '/anmelden',            :to => 'sessions#new', :as => :signin
  match '/abmelden',            :to => 'sessions#destroy', :as => :signout
  
  # Public pages, mostly static
  match '/wettbewerb',    :to => 'pages#competition', :as => :competition
  match '/regeln',        :to => 'pages#rules', :as => :rules
  match '/organisation',  :to => 'pages#organisation', :as => :organisation
  match '/kontakt',       :to => 'contacts#new', :as => :contact
  
  root :to => 'pages#home'
  
  # Legacy paths
  match '/ausschreibung' => redirect('/regeln')
  
  # Handling 404s
  match '*a', :to => 'pages#not_found'
end
