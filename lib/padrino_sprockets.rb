module PadrinoSprocekts
  class << self
    def registered(app)
      options = {}
      options[:asset_prefix] = -> { Sprockets::Helpers.prefix }
      app.use ::PadrinoSprocekts::Rack, options
    end

    def environment
      @environment ||= Sprockets::Environment.new(File.join(PADRINO_ROOT)) do |s|
        s.append_path File.expand_path File.join(PADRINO_ROOT, 'app/assets/javascripts')
        s.append_path File.expand_path File.join(PADRINO_ROOT, 'app/assets/stylesheets')
        s.append_path File.expand_path File.join(PADRINO_ROOT, 'app/assets/images')
        s.append_path File.expand_path File.join(PADRINO_ROOT, 'app/assets/vendor/javascripts')
        s.append_path File.expand_path File.join(PADRINO_ROOT, 'app/assets/vendor/stylesheets')
        s.append_path File.expand_path File.join(PADRINO_ROOT, 'app/assets/vendor/images')
        s.append_path File.expand_path File.join(PADRINO_ROOT, 'app/assets/components')
      end
    end
  end

  class Rack
    def initialize(app, options={})
      @app = app
      @asset_prefix = options[:asset_prefix].call
    end

    def call(env)
      if env['PATH_INFO'].match(@asset_prefix)
        env['PATH_INFO'].gsub!(@asset_prefix, '')
        return PadrinoSprocekts.environment.call(env)
      end

      @app.call(env)
    end
  end
end
