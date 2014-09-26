require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ReadyReckoner
  class Application < Rails::Application
    config.i18n.available_locales = ['en-CA', 'fr-CA']
    config.i18n.default_locale = 'en-CA'
    config.i18n.fallbacks = {'en-CA' => ['en-CA', :en, 'fr-CA', :fr], 'fr-CA' => ['fr-CA', :fr, 'en-CA', :en]}
    config.i18n.enforce_available_locales = false
  end
end
