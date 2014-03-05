source 'https://rubygems.org'

# Server requirements
gem 'unicorn'

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# sprockets support
gem 'sprockets'
gem 'sprockets-helpers'

# Component requirements
gem 'omniauth'
gem 'omniauth-twitter'
gem 'coffee-script'
gem 'sass'
gem 'haml'
gem 'activerecord', :require => "active_record"
gem 'mysql2'
gem 'twitter'

gem 'dotenv'

# Padrino Stable Gem
gem 'padrino', '~> 0.11.0'

group :development, :test do
  gem 'yui-compressor'
  gem 'uglifier'
  gem 'capistrano', require: false
  gem 'capistrano_colors', require: false
  gem 'capistrano-rbenv', require: false
  gem 'capistrano-unicorn', :require => false
  gem "pry"
  gem "pry-padrino"
  gem 'rspec'
end

group :test do
  gem 'poltergeist'
  gem 'rack-test', :require => "rack/test"
  gem 'webmock'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'selenium-webdriver'
end
