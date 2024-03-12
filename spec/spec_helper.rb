require 'capybara/dsl'
require 'selenium-webdriver'
require './server.rb'

Capybara.app = Sinatra::Application

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :remote,
    url: 'http://chrome:4444/wd/hub',
    options: Selenium::WebDriver::Chrome::Options.new(args: ['headless', 'disable-gpu'])
  )
end

Capybara.app_host = 'http://rebase-labs-server:3000'

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.server = :puma, { Silent: true }

RSpec.configure do |config|
  config.include Capybara::DSL
end
