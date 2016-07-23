require 'dotenv'
require 'rspec'
require 'active_support/all'
require 'pathname'
require 'site_prism' # Page object gem for feature tests

PROJECT_ROOT = Pathname.new('..').expand_path(File.dirname(__FILE__))

# Attempt to load environment variables from the .env file
Dotenv.load

# Enforce required environment vars
raise('Your URL environment variable is missing! Make sure your .env file is in place!') unless ENV['URL']

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[PROJECT_ROOT.join('spec/support/**/*.rb')].each { |f| require f }

# Requires page objects for feature tests
Dir[PROJECT_ROOT.join('spec/features/pages/sections/**/*.rb')].each { |f| require f }
Dir[PROJECT_ROOT.join('spec/features/pages/**/*.rb')].each { |f| require f }

TRUTHY_STRINGS = %w(t true y yes 1).flat_map do |str|
  [str.downcase, str.upcase, str.capitalize]
end.uniq

FALSEY_STRINGS = %w(f false n no 0).flat_map do |str|
  [str.downcase, str.upcase, str.capitalize]
end.uniq

RSpec.configure do |config|
  # General Config
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.alias_example_to :fit, focus: true
  config.filter_run_excluding broken: true
  # config.order                                      = 'random'
  config.fail_fast                                  = ENV['FAIL_FAST'].in? TRUTHY_STRINGS
  config.expose_dsl_globally                        = true

  # Includes
  config.include Capybara::DSL
  config.include UtilityHelpers
  config.include SitePrism::Additions

  config.after(:each) do |example|
    if example.exception
      take_screenshot!
    end
  end

end
