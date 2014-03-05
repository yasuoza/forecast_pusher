require 'dotenv'
Dotenv.load

Padrino.configure_apps do
  enable :sessions
  enable :caching

  set :session_secret, ENV['session_secret'] || '35865e7937c80ef57cad3a92015c9c05f44594fa20ca01118c50b60c8c560ab2'

  set :protection, true
  set :protect_from_csrf, true
  set :allow_disabled_csrf, true

  set :sprockets, PadrinoSprocekts.environment
  Sprockets::Helpers.configure do |config|
    manifest_path      = Padrino.root('public/assets/manifest.json')
    config.environment = sprockets
    config.prefix      = '/assets'
    config.manifest    = Sprockets::Manifest.new(sprockets, manifest_path)
    config.digest      = true
    config.public_path = public_folder

    if Padrino.env == :development
      config.expand    = true
      config.digest    = false
      config.manifest  = false
    end
  end
end

# Mounts the core application for this project
Padrino.mount("ForecastPusher").to('/')
