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
         raise SitePrism::TimeoutError unless displayed?
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

      # Takes a screenshot and stores it in the project ./tmp/ folder
      def take_screenshot!
         meta = RSpec.current_example.metadata
         filename = File.basename File.basename(meta[:file_path])
         line_number = meta[:line_number]

         # Build the screenshot name
         screenshot_name = [
             Time.now.to_i,
             SecureRandom.hex(3),
             filename,
             line_number,
         ].join('-') + '.png'

         tmp_dir = PROJECT_ROOT.join('tmp')
         screenshot_dir, _ = FileUtils.mkdir_p File.join tmp_dir, 'screenshots'
         screenshot_path = File.join screenshot_dir, screenshot_name

         # Save and inform
         page.save_screenshot(screenshot_path, full: true)
         puts '', meta[:full_description], "  Screenshot: #{screenshot_path}"
      end

      # Method that makes it easier to search a collection of sections or elements,
      # using the collection name and hash of method names and their expected values.
      # If search value is a regular expression, it will attempt to match the result
      # of the method with the specified regular expression.
      # Also accepts the "wait_time_seconds" parameter, if you want to override the default value
      #
      #   Example Usage:
      #
      #   class FooSection < SitePrism::Section
      #     element :title_element, '.title'
      #     element :name_element, '.name'
      #
      #     def title
      #       title_element.text
      #     end
      #
      #     def name
      #       name_element.text
      #     end
      #   end
      #
      #   def BarPage < SitePrism::Page
      #     sections :foo_sections, FooSection, '.foo'
      #   def
      #
      #   # Search on the Bar page for any Foo sections by both their name and title
      #   bar_page = BarPage.new
      #   found_foo_section = bar_page.find_in(:foo_sections, title: 'qux', name: 'baz')
      #
      #   # Search for a foo section whose name matches a regular expression, using a shorter wait time
      #   found_foo_section = bar_page.find_in(:foo_sections, name: /[0-9]abc/, wait_time_seconds: 5)
      #
      def find_in(collection_name, search_options = {})
         self.send("wait_for_#{collection_name.to_sym}")
         found_item = nil
         wait_time_seconds = search_options.delete(:wait_time_seconds) || Capybara.default_max_wait_time
         wait_until_true(wait_time_seconds) do
            found_item = self.send(collection_name.to_sym).find do |collection_item|
               search_options.keys.all? do |key|
                  method_name = key.to_sym
                  search_value = search_options[key]
                  if search_value.is_a? Regexp
                     (collection_item.send(method_name) =~ search_value).is_a?(Integer) rescue false
                  else
                     (collection_item.send(method_name) == search_value) rescue false
                  end
               end # Is true only if all of the specified methods returned the expected values for this item
            end # Returns the first item in the collection whose find block was true
            found_item.present?
         end
         found_item
      end

   end
end

SitePrism::Page.include SitePrism::Additions
SitePrism::Section.include SitePrism::Additions
