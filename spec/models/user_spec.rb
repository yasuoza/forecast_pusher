require 'spec_helper'

describe 'Users' do

  describe '#new' do
    subject { User.new }

    it 'can be created' do
      should_not be_nil
    end
  end

  describe '#find_or_create_from_auth' do
    context 'when new user login' do
      subject { User.find_or_create_from_auth(auth) }

      let(:auth) {
        {
          info: {
            nickname: 'Bob',
            name: 'Bobby',
            access_token: 'xxx',
            access_token_secret: 'yyy'
          },
          credentials: {
            token: 'aaa',
            secret: 'bbb'
          }
        }
      }

      it 'create new user' do
        lambda {
          subject
        }.should change(User, :count).by(1)
      end
    end

    context 'when sigined up user logged in' do
      before { User.create(screen_name: 'Marry',
                            access_token: 'aaa',
                            access_token_secret: 'bbb',
                            name: 'Marry') }

      subject { User.find_or_create_from_auth(auth) }

      let(:auth) {
        {
          info: {
            nickname: 'Marry',
            name: 'Marry',
            access_token: 'aaa',
            access_token_secret: 'bbb'
          },
          credentials: {
            token: 'aaa',
            secret: 'bbb'
          }
        }
      }

      it 'does not create new user' do
        lambda {
          subject
        }.should_not change(User, :count)
      end

      it "ensures there is Marry's record" do
        User.find_by_screen_name('Marry').should_not be nil
      end
    end
  end

  describe :has_point? do
    context 'when has no point' do
      before do
        User.create(screen_name: 'xxx')
        Point.create(area_id: 1, pref_id: 10, pref_name: 'Tokyo', area_name: 'Central')
      end

      subject { user.point }
      let(:user) { User.find_by_screen_name('xxx') }

      it { should be_false }
    end

    context 'when has point' do
      before do
        User.create(screen_name: 'xxx', pref_id: 10, area_id: 1)
        Point.create(area_id: 1, pref_id: 10, pref_name: 'Tokyo', area_name: 'Central')
      end

      subject { user.point }
      let(:user) { User.find_by_screen_name('xxx') }

      it { should be_true }
    end
  end

  describe 'scope' do
    let(:today_user) { User.create(pref_id: 1) }
    let(:next_user) { User.create(pref_id: 1, next_info: 1) }

    describe 'today_update_users_of' do
      subject { User.today_update_users_of(pref_id) }
      let(:pref_id) { 1 }

      it { should eq [today_user] }
    end

    describe 'next_update_users_of' do
      subject { User.next_update_users_of(pref_id) }
      let(:pref_id) { 1 }

      it { should eq [next_user] }
    end
  end

  describe :point do
    before do
      User.create(screen_name: 'xxx',area_id: 1,pref_id: 10)
      Point.create(area_id: 1, pref_id: 10, pref_name: 'Tokyo', area_name: 'Central')
    end

    subject { user.point }
    let(:user) { User.find_by_screen_name('xxx') }

    it { should eq Point.where(area_id: 1, pref_id: 10).first }
  end
end
