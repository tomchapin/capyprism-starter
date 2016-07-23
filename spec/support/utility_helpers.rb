require 'securerandom'

module UtilityHelpers
  def wait_until(timeout = 5)
    break_time = Time.now + timeout
    loop do
      begin
        result = yield
      rescue
        next
      ensure
        break result if result or Time.now > break_time
      end
    end
  end

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

  def take_screenshot!
    meta            = RSpec.current_example.metadata
    filename        = File.basename File.basename(meta[:file_path])
    line_number     = meta[:line_number]

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
end
