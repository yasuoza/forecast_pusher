ForecastPusher.controllers :auth do
  get ':name/callback' do
    auth = request.env["omniauth.auth"]
    session[:current_user] = User.find_or_create_from_auth(auth)
    redirect url(:index)
  end

  get :failure do
    redirect url(:index)
  end
end
