# frozen_string_literal: true

require 'capybara'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'rack/utils'
require_relative '../download_helpers'

# Comma-separated list of mime types which can be downloaded by the test driver
# Downloads are put into the project tmp/downloads/ folder
DOWNLOADABLE_MIME_TYPES = "application/x-bzip2"

default_firefox_options = begin
  profile = ::Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = DownloadHelpers::PATH.to_s
  profile['browser.download.folderList'] = 2 # custom location

  # Suppress "open with" dialog for certain mime types
  profile['browser.helperApps.neverAsk.saveToDisk'] = DOWNLOADABLE_MIME_TYPES

  Selenium::WebDriver::Firefox::Options.new(profile: profile)
end

default_chrome_options = begin
  prefs = {
    download: {
      prompt_for_download: false,
      default_directory: DownloadHelpers::PATH.to_s
    }
  }
  args = ['--window-size=1280,768', '--start-maximized']
  Selenium::WebDriver::Chrome::Options.new(prefs: prefs, args: args)
end

# Remote Selenium Server
Capybara.register_driver :selenium_server do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome
  Capybara::Selenium::Driver.new app,
                                 browser: :remote,
                                 url: ENV['SELENIUM_SERVER_URL'],
                                 desired_capabilities: capabilities
end

# Firefox
Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox, options: default_firefox_options)
end

# Firefox - Headless
Capybara.register_driver :firefox_headless do |app|
  options = default_firefox_options
  options.args << '--headless'

  Capybara::Selenium::Driver.new(app, browser: :firefox, options: default_firefox_options)
end

# Chrome
Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: default_chrome_options)
end

# Chrome - Headless
Capybara.register_driver :chrome_headless do |app|
  options = default_chrome_options
  options.headless!

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Enable screenshots for each type of browser
[:firefox, :firefox_headless, :chrome, :chrome_headless].each do |browser|
  Capybara::Screenshot.register_driver(browser) do |driver, path|
    driver.browser.save_screenshot(path)
  end
end

# Capybara Configuration
Capybara.configure do |config|
  config.server_port = 64515
  config.javascript_driver = (ENV['WEBDRIVER'] || :chrome).to_sym
  config.default_max_wait_time = 30
  config.run_server = false # don't start Rack
  config.app_host = ENV['URL']
end