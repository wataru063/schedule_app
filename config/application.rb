require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ScheduleApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]

    config.generators do |g|
      g.test_framework :rspec,
      controller_specs: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false
    end

    config.time_zone = 'Tokyo'
    config.action_view.embed_authenticity_token_in_remote_forms = true

  end
end