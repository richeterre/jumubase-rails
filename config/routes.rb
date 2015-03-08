Jmd::Application.routes.draw do

  # Routes for internal (JMD) pages

  namespace :jmd do
    resources :categories, :users
    resources :competitions do
      resources :appearances, only: [:index, :update]
      resources :participants, only: [:index, :show]
      resources :performances, only: :index do
        get 'make_certificates', on: :collection
        get 'make_jury_sheets', on: :collection
        get 'make_result_sheets', on: :collection
      end
      resources :venues, only: [] do
        get 'schedule', on: :member
      end
      get 'list_advancing', on: :member
      post 'migrate_advancing', on: :member
      get 'welcome_advanced', on: :member
      get 'schedule_classical', on: :member
      get 'schedule_popular', on: :member
    end
    resources :hosts, only: [:index, :show]
    resources :performances, except: :index do
      get 'list_current', on: :collection
      put 'reschedule', on: :member
    end
  end


  # Routes for public pages

  resources :contacts, only: [:new, :create]
  resources :sessions, only: [:create, :destroy]

  # Routes for performance timetables
  if JUMU_TIMETABLES_PUBLIC
    match 'zeitplan/klassik/:year-:month-:day', to: 'competitions#classical_schedule', as: :classical_schedule
    match 'zeitplan/pop/:year-:month-:day', to: 'competitions#popular_schedule', as: :popular_schedule
  end

  # Routes for signup and performance editing, if currently possible
  if JUMU_SIGNUP_OPEN
    if JUMU_ROUND == 1
      resources :performances, only: [:new, :create, :edit, :update]
    else
      resources :performances, only: [:edit, :update] # no signup after round 1
    end
    match '/vorspiel-bearbeiten', to: 'performances#search', as: :signup_search
  end

  # User session routes
  match '/anmelden',      to: 'sessions#new', as: :signin
  match '/abmelden',      to: 'sessions#destroy', as: :signout

  # Public pages, mostly static
  match "lw#{JUMU_YEAR}", to: 'pages#lw', as: :lw
  match '/wettbewerb',    to: 'pages#competition', as: :competition
  match '/regeln',        to: 'pages#rules', as: :rules
  match '/kontakt',       to: 'contacts#new', as: :contact

  root to: 'pages#home'

  # Handling 404s
  match '*a', to: 'pages#not_found'
end
