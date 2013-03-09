module OmniauthInitializer
  def self.registered(app)
    app.use OmniAuth::Builder do
      provider :developer unless Padrino.env == :production
      provider :twitter,
        ForcastTweeter.defaults[:consumer_key],
        ForcastTweeter.defaults[:consumer_secret]
    end
  end
end
