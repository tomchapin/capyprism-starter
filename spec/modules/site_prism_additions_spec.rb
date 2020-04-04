# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'SitePrism::Additions' do

  describe 'wait_until_true' do
    it 'allows you to ignore all exceptions' do
      expect {
        current_iteration = 0
        wait_until_true(retry_on_all_exceptions: true) do
          current_iteration += 1
          if current_iteration == 1
            raise Selenium::WebDriver::Error::StaleElementReferenceError
          elsif current_iteration == 2
            raise Selenium::WebDriver::Error::NoSuchAlertError
          elsif current_iteration == 3
            true
          end
        end
      }.to_not raise_exception
    end

    it 'allows you to ignore multiple exceptions' do
      expect {
        current_iteration = 0
        wait_until_true(retry_on_exceptions: [Selenium::WebDriver::Error::StaleElementReferenceError, Selenium::WebDriver::Error::NoSuchAlertError]) do
          current_iteration += 1
          if current_iteration == 1
            raise Selenium::WebDriver::Error::StaleElementReferenceError
          elsif current_iteration == 2
            raise Selenium::WebDriver::Error::NoSuchAlertError
          elsif current_iteration == 3
            true
          end
        end
      }.to_not raise_exception
    end

    it 'raises any other non-ignored exceptions' do
      expect {
        current_iteration = 0
        wait_until_true(retry_on_exceptions: [Selenium::WebDriver::Error::StaleElementReferenceError]) do
          current_iteration += 1
          if current_iteration == 1
            raise Selenium::WebDriver::Error::StaleElementReferenceError
          elsif current_iteration == 2
            raise Selenium::WebDriver::Error::NoSuchAlertError
          elsif current_iteration == 3
            true
          end
        end
      }.to raise_error(Selenium::WebDriver::Error::NoSuchAlertError)
    end
  end

  describe 'fail_gracefully' do
    it 'allows you to ignore all exceptions and return a value on failure' do
      result = fail_gracefully(on_all_exceptions: true, value_on_failure: :foo) do
        raise Selenium::WebDriver::Error::StaleElementReferenceError
      end
      expect(result).to eq :foo
    end


    it 'allows you to ignore a single exception and return a value on failure' do
      result = fail_gracefully(on_exceptions: [Selenium::WebDriver::Error::StaleElementReferenceError], value_on_failure: :foo) do
        raise Selenium::WebDriver::Error::StaleElementReferenceError
      end
      expect(result).to eq :foo
    end

    it 'allows you to ignore a multiple exceptions at the same time and return a value on failure' do
      exceptions_to_ignore = [Selenium::WebDriver::Error::StaleElementReferenceError, Selenium::WebDriver::Error::NoSuchAlertError]

      result1 = fail_gracefully(on_exceptions: exceptions_to_ignore, value_on_failure: :foo) do
        raise Selenium::WebDriver::Error::StaleElementReferenceError
      end
      expect(result1).to eq :foo

      result2 = fail_gracefully(on_exceptions: exceptions_to_ignore, value_on_failure: :bar) do
        raise Selenium::WebDriver::Error::NoSuchAlertError
      end
      expect(result2).to eq :bar
    end

    it 'can be configured to raise other non-ignored exceptions' do
      expect {
        fail_gracefully(on_exceptions: [Selenium::WebDriver::Error::StaleElementReferenceError], raise_other_exceptions: true) do
          raise Selenium::WebDriver::Error::NoSuchAlertError
        end
      }.to raise_error(Selenium::WebDriver::Error::NoSuchAlertError)
    end
  end

end