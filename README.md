# CapyPrism Starter

This is a bare metal starter project that makes use of Capybara, SitePrism, and RSpec to run
frontend web browser feature tests against remote URLs. It also includes some small helper
extension methods for the SitePrism page objects (which make my life easier).


## Pre-requisites

- Ruby (tested with version 2.3.1)
- Bundler (run `gem install bundler` to install it if you don't have it)
- Firefox (tested with version 47.0.1)


## Setup and How to Use

1. Run `bundle install` to install all of the necessary gems.
2. Run `rspec` to launch the test suite.


## More Information

- Capybara Documentation - https://github.com/jnicklas/capybara
- SitePrism Documentation - https://github.com/natritmeyer/site_prism