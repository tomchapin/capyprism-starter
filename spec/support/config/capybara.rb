require 'capybara'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'selenium-webdriver'
require 'rack/utils'
require_relative '../download_helpers'

Capybara.register_driver :selenium_server do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome
  Capybara::Selenium::Driver.new app,
                                 browser: :remote,
                                 url: ENV['SELENIUM_SERVER_URL'],
                                 desired_capabilities: capabilities
end

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = DownloadHelpers::PATH.to_s
  profile['browser.download.folderList'] = 2 # custom location

  # Suppress "open with" dialog for certain mime types
  profile['browser.helperApps.neverAsk.saveToDisk'] = DOWNLOADABLE_MIME_TYPES
  Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)
end

# ChromeDriver 1.x, for Chrome <= 28
# Capybara.register_driver :chrome do |app|
#   profile = Selenium::WebDriver::Chrome::Profile.new
#   profile['download.default_directory'] = DownloadHelper::PATH.to_s
#   args = ["--window-size=1280,720"]
#   Capybara::Selenium::Driver.new(app, browser: :chrome, profile: profile, args: args)
# end

# ChromeDriver 2.x, for Chrome >= 29
Capybara.register_driver :chrome do |app|
  prefs = {
      download: {
          prompt_for_download: false,
          default_directory: DownloadHelper::PATH.to_s
      }
  }
  args = ['--window-size=1280,720', '--start-maximized']
  Capybara::Selenium::Driver.new(app, browser: :chrome, prefs: prefs, args: args)
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
  config.app_host   = ENV['URL']
end