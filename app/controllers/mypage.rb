ForecastPusher.controllers :mypage do

  before do
    authenticate_user!
  end

  get :index do
    render 'mypage/index'
  end

end
