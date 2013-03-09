PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")
require 'capybara/rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |conf|
  conf.include Rack::Test::Methods

  # Database cleaner configuration
  conf.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  conf.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  conf.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  conf.before(:each) do
    DatabaseCleaner.start
  end

  conf.after(:each) do
    DatabaseCleaner.clean
  end
end

def fixture_path
  File.join(__dir__, 'fixtures')
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  fake.string
end

def app
  ##
  # You can handle all padrino applications using instead:
  #   Padrino.application
  ForecastPusher.tap { |app|  }
end

if ENV['POLTERGEIST']
  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist
else
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
  Capybara.javascript_driver = :chrome
end
Capybara.app = app
