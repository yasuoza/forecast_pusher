ForecastPusher.controllers :users do
  before do
    authenticate_user!
  end

  post :register do
    next_info = 1 if params[:next_info]

    current_user.update_attributes!(pref_id: params[:pref_id].to_i,
                                    area_id: params[:area_id].to_i,
                                    next_info: next_info)

    flash[:notice] = 'Point registered'
    redirect url(:index)
  end

  delete :init do
    current_user.update_attributes!(pref_id: nil, area_id: nil)

    flash[:notice] = 'Point deleted'
    redirect url_for(:mypage, :index)
  end

  delete :destroy do
    User.destroy(current_user.to_param)
    session[:current_user] = nil

    flash[:notice] = 'See you someday...'
    redirect url(:index)
  end

end
