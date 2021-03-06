# CapyPrism Starter

This is a bare metal starter project that makes use of Capybara, SitePrism, and RSpec to run
frontend web browser feature tests against remote URLs. It also includes some small helper
extension methods for the SitePrism page objects (which make my life easier).


## Pre-requisites

- Ruby (tested with v2.4.1)
- Bundler (run `gem install bundler` to install it if you don't have it)
- Firefox (tested with Firefox v69.0.3 - 64-bit)
- Geckodriver (tested with v0.26.0 - run `brew install geckodriver` if you don't have it)
- Chrome (tested with v70)
- Chromedriver (tested with v78.0.3904.70 - run `brew tap homebrew/cask && brew cask install chromedriver` if you don't have it)


## Setup and How to Use

1. Copy the `.env` file to a file named `.env.local` and edit it according to your preferences.
   
2. Run `bundle install` to install all of the necessary gems.

3. Run `bundle exec rspec` to launch the test suite.

To use different web browsers, simply set your 'WEBDRIVER' environment variable.
The options available for the WEBDRIVER setting are:
- `chrome`
- `chrome_headless`
- `firefox`
- `firefox_headless`

## More Information

- Capybara Documentation - https://github.com/jnicklas/capybara
- SitePrism Documentation - https://github.com/site-prism/site_prism
