# CapyPrism Starter

This is a bare metal starter project that makes use of Capybara, SitePrism, and RSpec to run
frontend web browser feature tests against remote URLs. It also includes some small helper
extension methods for the SitePrism page objects (which make my life easier).


## Pre-requisites

- Ruby (tested with ver 2.3.1)
- Bundler (run `gem install bundler` to install it if you don't have it)
- Firefox (tested with ver 47.0.1)
- Chrome (tested with ver 51)
- Chromedriver (tested with ver 2.22 - run `brew install chromedriver` if you don't have it)
- Poltergeist (tested with ver 2.1.1 - run `brew install phantomjs` if you don't have it)
- Docker (if you want to use the docker-based selenium grid)

## Setup and How to Use

1. Copy the `.env-example` file to `.env` and make sure the URL variable is pointed at the right place
   
2. Run `make install` to install all of the necessary gems.

3. Run `docker pull elgalu/selenium` to fetch the Docker image for the Selenium grid

4. Run `make start-selenium-server`. If this worked correctly, you should be able to browse to
   http://localhost:4444/grid/console to see your Selenium server console.

5. Run `make run` to launch the test suite.

To use different web browsers, simply set your 'WEBDRIVER' environment variable.
You can choose between selenium-server (remote or docker grid), selenium (firefox), chrome, or poltergeist

To stop your selenium server, simply run `make stop-selenium-server`.


## More Information

- Capybara Documentation - https://github.com/jnicklas/capybara
- SitePrism Documentation - https://github.com/natritmeyer/site_prism
