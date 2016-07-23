require 'capybara'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'rack/utils'

Capybara.register_driver :selenium_server do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome
  Capybara::Selenium::Driver.new app,
                                 browser: :remote,
                                 url: ENV['SELENIUM_SERVER_URL'],
                                 desired_capabilities: capabilities
end

Capybara.register_driver :chrome do |app|
  custom_app = '/Applications/Google Chrome for Selenium.app'
  if File.exist? custom_app
    bin = File.join(custom_app, 'Contents/MacOS/Google Chrome')
    caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"binary" => bin}, "args" => ['--start-maximized'])
    Capybara::Selenium::Driver.new app, browser: :chrome, desired_capabilities: caps
  else
    Capybara::Selenium::Driver.new app, browser: :chrome
  end
end

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new app,
                                    inspector: true,
                                    phantomjs_options: %w(--load-images=yes),
                                    js_errors: false,
                                    timeout: 60
end

# Capybara Configuration
Capybara.configure do |config|
  config.server_port = 64515
  config.javascript_driver = (ENV['WEBDRIVER'] || :selenium).to_sym
  config.default_max_wait_time = 30
  config.run_server = false # don't start Rack
  config.app_host   = ENV['URL'] || 'https://www.google.com/'
end



