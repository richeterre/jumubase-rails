source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.19'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'jquery-rails'
gem 'jquery-ui-rails'

gem 'amoeba' # Deep record duplication
gem 'cancan' # Authorization
gem 'has_scope' # Record filtering
gem 'simple_form' # Form builder
gem 'will_paginate' # Pagination
gem 'bootstrap-will_paginate'

gem 'sass-rails',     '~> 3.2.3'
gem 'bootstrap-sass', '~> 2.3.0.0'

gem 'prawn' # PDF output
gem 'prawnto_2', require: 'prawnto'

gem 'comma' # CSV output

gem 'coffee-rails',   '~> 3.2.1'

gem 'delayed_job_active_record'
gem 'workless' # Auto-scale Heroku workers
gem "daemons" # Required for workless to do its job

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'uglifier',       '>= 1.0.3'
end

group :test, :development do
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails'
  gem 'annotate'
  gem 'email_spec'
  gem 'action_mailer_cache_delivery'
  gem 'bullet'
end

group :test do
  gem 'capybara',         '~> 2.0'
  gem 'database_cleaner'
  gem 'launchy'
end

group :production do
  gem 'newrelic_rpm', '3.5.5.38'
end

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
