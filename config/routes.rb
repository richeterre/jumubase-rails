Jumubase::Application.routes.draw do

  # Routes for public API

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :contests, only: :index do
        resources :performances, only: :index
      end
    end
  end

  # Routes for internal (JMD) pages

  devise_for :users, path: '', path_names: {
    sign_in: 'anmelden',
    sign_out: 'abmelden'
  }

  namespace :jmd do
    resources :categories, :users
    resources :contests do
      resources :appearances, only: [:index, :update]
      resources :participants, only: [:index, :show]
      resources :performances, only: [:index, :new, :create] do
        get 'make_certificates', on: :collection
        get 'make_jury_sheets', on: :collection
        get 'publish_results', on: :collection
        post 'set_results_publicity', on: :collection
      end
      resources :venues, only: [] do
        get 'schedule', on: :member
      end
      get 'show_timetables', on: :member
      get 'list_advancing', on: :member
      post 'migrate_advancing', on: :member
      get 'welcome_advanced', on: :member
    end
    resources :hosts, only: [:index, :show]
    resources :performances, except: [:index, :new, :create] do
      get 'list_current', on: :collection
      put 'reschedule', on: :member
    end

    # Routes for internal static pages
    match '/statistics', to: 'pages#statistics', as: :statistics
    root to: 'pages#welcome'
  end

  # Routes for public pages

  resources :contacts, only: [:new, :create]

  resources :contests, only: [] do
    get 'performances', on: :member
  end

  # Routes for signup and performance editing, if currently possible
  if JUMU_SIGNUP_OPEN
    if JUMU_ROUND == 1
      resources :contests, only: [] do
        resources :performances, only: [:new, :create]
      end

      match '/anmeldung', to: 'contests#signup', as: :signup
    end

    resources :performances, only: [:edit, :update] # no signup after round 1

    match '/vorspiel-bearbeiten', to: 'performances#search', as: :signup_search
  end

  # Public pages, mostly static
  match '/wettbewerb',    to: 'pages#competition', as: :competition
  match '/regeln',        to: 'pages#rules', as: :rules
  match '/faq',           to: 'pages#faq', as: :faq
  match '/kontakt',       to: 'contacts#new', as: :contact

  root to: 'pages#home'

  # Handling 404s
  match '*a', to: 'pages#not_found'
end
