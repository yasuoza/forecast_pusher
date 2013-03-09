# encoding:utf-8

require 'spec_helper'
require 'date'

describe 'UpdateTextBuilder' do

  shared_examples 'a point information' do
    it { should match '宮城' }
    it { should match '東部' }
  end

  shared_examples "a today's information" do
      it { should match /今(日|夜)#{Date.today.day}日/ }
  end

  shared_examples "a tomorrows's information" do
      it { should match "明日#{Date.today.succ.day}日" }
  end

  shared_examples 'a tweet status' do
    its(:length) { should be <= 140 }
  end

  describe '#build' do
    subject { UpdateTextBuilder.build(5, 0, next_update) }

    context 'when next_update == false' do
      let(:next_update) { next_update = false }

      it_behaves_like 'a point information'
      it_behaves_like "a today's information"
    end

    context 'when next_update == true' do
      let(:next_update) { next_update = true }

      it_behaves_like 'a point information'
      it_behaves_like "a tomorrows's information"
    end
  end

  describe '#build_for' do
    subject { UpdateTextBuilder.build_for('uname' * 10, 5, 0, next_update) }

    context 'when next_update == false' do
      let(:next_update) { next_update = false }

      it_behaves_like 'a point information'
      it_behaves_like "a today's information"
      it_behaves_like 'a tweet status'
      it { should match '...' }
    end

    context 'when next_update == true' do
      let(:next_update) { next_update = true }

      it_behaves_like 'a point information'
      it_behaves_like "a tomorrows's information"
      it_behaves_like 'a tweet status'
      it { should match '...' }
    end
  end

end
