# spec/spec_helper.rb
require 'capybara/dsl'
require 'selenium-webdriver'
require './server.rb'

Capybara.app = Sinatra::Application

Capybara.register_driver :selenium do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless') # Executar o Chrome em modo headless
  options.add_argument('--no-sandbox') # Necessário para execução no Docker
  options.add_argument('--disable-dev-shm-usage') # Necessário para execução no Docker
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.server = :puma, { Silent: true }

RSpec.configure do |config|
  config.include Capybara::DSL
end
