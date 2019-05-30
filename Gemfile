source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.11'

gem 'mysql2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

gem 'cancancan'
gem 'blacklight', '~> 5.19.2'
gem 'rsolr', '~>1.0'
gem 'rails_autolink'
gem 'haml'
gem 'aws-sdk', '< 2'
gem 'sidekiq', '~> 3.5.4'
gem 'sinatra', require: false
gem 'sidekiq-failures'
gem 'devise'
gem 'devise-guests'
gem 'carrierwave'
gem 'mini_magick'
gem 'rmagick'
gem 'rest-client', '~>1.8'
gem 'rails_admin', '~> 1.3.0'
gem 'piet'
gem 'piet-binary'
gem 'kaminari'
gem 'friendly_id', '~> 5.1.0' # Note: You MUST use 5.0.0 or greater for Rails 4.0+
gem 'sanitize', '~> 4.6.3'
gem 'coderay', '~> 1.0.5'
gem 'google-api-client', '0.8.6'
gem 'activerecord-import'
gem 'whenever', :require => false
gem 'redis-rails'

group :test, :development do
  # Debug seems to have trouble w/ Ruby 2.x, byebug is a replacment
  gem 'byebug'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  # Quite logs down by removing asset requests
  gem 'quiet_assets'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'faker'
  gem 'capistrano-sidekiq'
end

# Gemfile (never include in :development !)
group :test do
  gem 'test_after_commit'
  gem 'webmock'
end