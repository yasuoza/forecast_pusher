require 'spec_helper'


describe 'Login with Twitter', type: :feature do
  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  subject { page }

  context 'when not logged in' do
    it 'shows login link' do
      visit '/'
      should have_selector '#login-with-twitter'
    end
  end

  context 'when logged in' do
    it 'shows register form' do
      OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
        provider: 'twitter',
        uid: '123545',
        info: {
          nickname: 'xxx'
        },
        credentials: {
          token: 'aaa',
          secret: 'bbb'
        }
      })
      visit '/auth/twitter'
      should have_selector 'form#registration'
    end
  end
end
