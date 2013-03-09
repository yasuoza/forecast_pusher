require 'spec_helper'

describe "Points Model" do
  subject { Point.new }

  it 'can be created' do
    should_not be_nil
  end
end
