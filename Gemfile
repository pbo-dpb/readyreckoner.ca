source 'https://rubygems.org'
ruby '2.1.5'

# Rails
gem 'rails', '4.1.8'
gem 'pg'

# Assets
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'

# Engines
gem 'citizen_budget_model', git: 'https://github.com/opennorth/citizen_budget_model.git'
gem 'gettext'
gem 'rails-i18n', '~> 4.0.0'
gem 'devise-i18n', '~> 0.10.4'

# PDF generation
gem 'prawn'
gem 'prawn-table'
gem 'unicode_utils'

gem 'rack-mobile-detect'

group :development do
  gem 'spring'
  gem 'pry-rails'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'coveralls'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
end
