require 'spec_helper'

describe 'Visit mypage', type: :feature do
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

  subject { page }

  context 'when no point registered' do
    before do
      visit '/auth/twitter'
      visit '/mypage'
    end

    it 'shows no point message' do
      should have_selector '#not-registered'
      should_not have_selector '#registered'
    end
  end

  context 'when point registered' do
    before do
      User.create(screen_name: 'xxx',
                   pref_id: 12,
                   area_id: 0)
      Point.create(pref_name: 'Tokyo',
                    area_name: 'center',
                    pref_id: 12,
                    area_id: 0)
      visit '/auth/twitter'
      visit '/mypage'
    end

    it 'shows registered message' do
      should_not have_selector '#not-registered'
      should have_selector '#registered'
      should have_content 'Tokyo : center'
    end
  end

  describe 'DELETE /init' do
    subject { User.find_by_screen_name('xxx') }

    before do
      User.create(screen_name: 'xxx',
                   pref_id: 12,
                   area_id: 0)
      Point.create(pref_name: 'Tokyo',
                    area_name: 'center',
                    pref_id: 12,
                    area_id: 0)
      visit '/auth/twitter'
      visit '/mypage'
      click_button('init')
      page.driver.browser.switch_to.alert.accept unless Capybara.javascript_driver == :poltergeist
    end

    it "deletes user's registered point", js: true do
      current_url.should match(/\/mypage/)
      subject.pref_id.should be_nil
      subject.area_id.should be_nil
      page.should have_selector '#not-registered'
    end
  end

  describe 'DELETE /destory' do
    subject { User.find_by_screen_name('xxx') }

    before do
      User.create(screen_name: 'xxx',
                   pref_id: 12,
                   area_id: 0)
      Point.create(pref_name: 'Tokyo',
                    area_name: 'center',
                    pref_id: 12,
                    area_id: 0)
      visit '/auth/twitter'
      visit '/mypage'
      click_button('destroy')
      page.driver.browser.switch_to.alert.accept unless Capybara.javascript_driver == :poltergeist
    end

    it "deletes user's record", js: true do
      current_url.should match(/:\d{4,}\//)
      subject.should be_nil
    end
  end
end
