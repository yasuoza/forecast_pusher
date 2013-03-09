require 'spec_helper'

describe 'not_found', type: :feature do
  before do
    visit '/not_found_page'
  end

  it 'returns 404 status' do
    status_code.should eq 404
  end

  it 'returns 404 page' do
    page.should have_content 'Page not found ...'
  end
end
