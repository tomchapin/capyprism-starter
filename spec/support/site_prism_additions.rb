# Custom errors
class PageLoadTimeoutError < StandardError
end

# Additional methods for SitePrism Page objects and for rspec tests
module SitePrism
  module Additions

    # Wait until the page is displayed, or throw an error if it times out.
    # Note: This requires the url_matcher to be defined on the page object
    #
    # Example Usage:
    #
    #   @foo = Pages::Foo.new
    #   @foo.wait_until_loaded
    #
    def wait_until_loaded
      raise SitePrism::TimeoutException unless displayed?
      wait_for_javascript
    end

    # Wait until the given block returns true, or throw an error if it times out.
    #
    # Example Usage:
    #
    #   wait_until_true(5) { has_foo_element? }
    #
    def wait_until_true(*args, &block)
      SitePrism::Waiter.wait_until_true(*args, &block)
    end

    # Tells if AJAX requests are currently active or not on the page
    # @see https://coderwall.com/p/aklybw/wait-for-ajax-with-capybara-2-0
    def finished_all_ajax_requests?
      return_value = page.evaluate_script <<-SCRIPT.strip.gsub(/\s+/, ' ')
      (function () {
        if (typeof jQuery != 'undefined') {
          return jQuery.active;
        }
        else {
          console.log("Failed on the page: " + document.URL);
          console.error("An error occurred when checking for `jQuery.active`.");
        }
      })()
      SCRIPT
      return_value && return_value.zero?
    end

    # Wait for the client-side javascript to initialize and for any AJAX requests to fully complete
    def wait_for_javascript(wait_time_seconds = Capybara.default_wait_time)
      Timeout.timeout(wait_time_seconds) do
        loop do
          # Note: The window.fullyInitialized variable is set on the window by application.js
          break if page.evaluate_script('window.fullyInitialized') && finished_all_ajax_requests?
        end
      end
    rescue Timeout::Error
      raise PageLoadTimeoutError
    end

    # Clear the javascript status variable (use this before reloading the page)
    def reset_javascript_status
      page.evaluate_script('window.fullyInitialized = false;')
    end

    def reload_current_page
      reset_javascript_status
      page.driver.browser.navigate.refresh
      wait_for_javascript
    end

    # Accept alert
    def accept_javascript_alert
      page.driver.browser.switch_to.alert.accept rescue nil
    end

    # Clear cookies in the web browser
    def clear_cookies
      browser = Capybara.current_session.driver.browser
      if browser.respond_to?(:manage) and browser.manage.respond_to?(:delete_all_cookies)
        # Selenium::WebDriver
        browser.manage.delete_all_cookies
      elsif browser.respond_to?(:clear_cookies)
        # Rack::MockSession
        browser.clear_cookies
      else
        raise "Don't know how to clear cookies. Weird driver?"
      end
    end

    # Scroll the browser window
    def scroll_by(x: 0, y: 0)
      page.evaluate_script "window.scrollBy(#{x},#{y});"
    end

    # Scroll to bottom of the page
    def scroll_to_bottom_of_page
      scroll_by y: 100000
    end
  end
end

SitePrism::Page.include SitePrism::Additions
SitePrism::Section.include SitePrism::Additions
