require 'spec_helper'


describe 'Login with Twitter', type: :feature do
  before do
    OmniAuth.config.test_mode = true
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
  end

  after do
    OmniAuth.config.test_mode = false
  end

  subject { page.html }

  context 'when point not registered' do
    before do
      visit '/auth/twitter'
    end

    it 'does not attribute regsitered point' do
      should match "<select id='areas' name='area_id'></select>"
    end
  end

  context 'when point regiseterd' do
    before do
      User.create(screen_name: 'xxx',
                   pref_id: 12,
                   area_id: 0)

      visit '/auth/twitter'
    end

    it 'does not attribute regsitered point' do
      should match "<select data-registered='0' id='areas' name='area_id'>"
    end
  end
end

