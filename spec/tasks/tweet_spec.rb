require 'spec_helper'
require 'rake'

describe 'tweet' do
  before :all do
    load Padrino.root('tasks/tweet.rake')
    Rake::Task.define_task :environment
  end

  before :each do
    stub_request(:post, %r(api.twitter.com/oauth2/token))
      .to_return(status: 200, body: "")
  end

  let(:endpoint) { Twitter::REST::Client::ENDPOINT + "/1.1/statuses/update.json" }

  let :run_today_rake_task do
    Rake::Task['tweet:forecast'].reenable
    Rake.application.invoke_task 'tweet:forecast'
  end

  let :run_next_rake_task do
    Rake::Task['tweet:next:forecast'].reenable
    Rake.application.invoke_task 'tweet:next:forecast'
  end

  context 'when normally udpates' do
    let!(:today_user) do
      User.create(screen_name: 'xxx',
                  pref_id: 5,
                  area_id: 0,
                  access_token: 'AT',
                  access_token_secret: 'AS',
                  update_error_count: 5)
    end

    let!(:next_user) do
      User.create(screen_name: 'yyy',
                  pref_id: 5,
                  area_id: 0,
                  next_info: 1)
    end

    let!(:next_only_user) do
      User.create(screen_name: 'zzz',
                  pref_id: 12,
                  area_id: 0,
                  next_info: 1,
                  next_only: true)
    end


    describe ':forecast' do

      it "update today's forecast" do
        first_status = UpdateTextBuilder.build_for(today_user.screen_name,
                                                   today_user.pref_id.to_i,
                                                   today_user.area_id.to_i)

        next_status = UpdateTextBuilder.build_for(next_user.screen_name,
                                                  next_user.pref_id.to_i,
                                                  next_user.area_id.to_i)

        next_only_status = UpdateTextBuilder.build_for(next_only_user.screen_name,
                                                       next_only_user.pref_id.to_i,
                                                       next_only_user.area_id.to_i)

        stub_request(:post, endpoint)
          .with(body: {status: first_status})
          .to_return(body: fixture('status.json'), headers: {})
        stub_request(:post, endpoint)
          .with(body: {status: next_status})
          .to_return(body: fixture('status.json'), headers: {})
        stub_request(:post, endpoint)
          .with(body: {status: next_only_status})
          .to_return(body: fixture('status.json'), headers: {})

        run_today_rake_task

        a_request(:post, endpoint).with(body: {status: first_status}).should have_been_made
        a_request(:post, endpoint).with(body: {status: next_status}).should have_been_made
        a_request(:post, endpoint).with(body: {status: next_only_status}).should_not have_been_made
      end
    end

    describe ':next:forecast' do
      it "update tomorrow's forecast" do
        today_user_status = UpdateTextBuilder.build_for(today_user.screen_name,
                                                        today_user.pref_id.to_i,
                                                        today_user.area_id.to_i,
                                                        true)

        next_user_status = UpdateTextBuilder.build_for(next_user.screen_name,
                                             next_user.pref_id.to_i,
                                             next_user.area_id.to_i,
                                             true)

        next_only_status = UpdateTextBuilder.build_for(next_only_user.screen_name,
                                                       next_only_user.pref_id.to_i,
                                                       next_only_user.area_id.to_i,
                                                       true)


        stub_request(:post, endpoint)
          .with(body: {status: today_user_status})
          .to_return(body: fixture('status.json'), headers: {})
        stub_request(:post, endpoint)
          .with(body: {status: next_user_status})
          .to_return(body: fixture('status.json'), headers: {})
        stub_request(:post, endpoint)
          .with(body: {status: next_only_status})
          .to_return(body: fixture('status.json'), headers: {})

        run_next_rake_task

        a_request(:post, endpoint).with(body: {status: today_user_status}).should_not have_been_made
        a_request(:post, endpoint).with(body: {status: next_user_status}).should have_been_made
        a_request(:post, endpoint).with(body: {status: next_only_status}).should have_been_made
      end
    end
  end

  context 'when threre are some outdated user' do
    let(:outdated_user) { User.create(screen_name: 'zzz',
                                      pref_id: 5,
                                      area_id: 0,
                                      update_error_count: 5) }

    let(:user) { User.find(outdated_user.to_param) }
    it 'delete user pref_id and area_id' do
      status = UpdateTextBuilder.build_for(outdated_user.screen_name,
                                           outdated_user.pref_id.to_i,
                                           outdated_user.area_id.to_i)

      stub_request(:post, endpoint)
        .with(body: {status: status})
        .to_return(status: 401, body: "", headers: {})

        expect {
          run_today_rake_task
        }.to raise_error(RuntimeError)

        user.pref_id.should be_nil
        user.update_error_count.should eq 0
    end
  end

  context ' when there is nearly outdated user' do
    let(:near_outdated_user) { User.create(screen_name: '123',
                                           pref_id: 5,
                                           area_id: 0,
                                           update_error_count: 4) }

    it 'increment update_error_count by 1' do
      status = UpdateTextBuilder.build_for(near_outdated_user.screen_name,
                                           near_outdated_user.pref_id.to_i,
                                           near_outdated_user.area_id.to_i)

      stub_request(:post, endpoint)
        .with(body: {status: status})
        .to_return(status: 401,  body: "", headers: {})

        lambda {
          capture_stdout { run_today_rake_task }
        }.should_not raise_error

        near_outdated_user.pref_id.should eq 5
    end
  end

end
