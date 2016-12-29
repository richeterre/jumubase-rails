source 'https://rubygems.org'

gem 'rails', '3.2.22.5'

# Get Ruby version from .ruby-version file
ruby File.read(".ruby-version").strip

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'devise' # Authentication
gem 'cancancan' # Authorization

gem 'amoeba' # Deep record duplication
gem 'has_scope' # Record filtering

gem 'simple_form' # Form builder

gem 'will_paginate' # Pagination
gem 'bootstrap-will_paginate'

gem 'sass-rails',     '3.2.6'
gem 'bootstrap-sass', '3.1.1'

gem 'prawn' # PDF output
gem 'prawnto_2', require: 'prawnto'

gem 'comma' # CSV output
gem 'jbuilder' # JSON output

gem 'coffee-rails',   '~> 3.2.1'

gem 'delayed_job_active_record'
gem 'workless' # Auto-scale Heroku workers
gem 'daemons' # Required for workless to do its job

gem 'skylight' # Profile app using Skylight.io

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'uglifier',       '>= 1.0.3'
end

group :development do
  gem 'rack-mini-profiler' # Measure app performance
end

group :test, :development do
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails'
  gem 'annotate'
  gem 'email_spec'
  gem 'action_mailer_cache_delivery'
  gem 'bullet'
  gem 'byebug'
end

group :test do
  gem 'capybara',         '~> 2.0'
  gem 'database_cleaner'
  gem 'launchy'
end

group :production do
  gem 'newrelic_rpm'
end

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
