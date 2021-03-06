# frozen_string_literal: true

require 'pry'
require_relative '../../spec_helper'

feature 'Google - Search', type: :feature, js: true do

  scenario 'visiting the Google home page and searching for the word "capybara"' do
    home_page.load
    home_page.search_for(text: 'capybara')

    expect(home_page).to have_content 'Capybara - Wikipedia'

    Capybara::Screenshot.screenshot_and_save_page
    Capybara::Screenshot.screenshot_and_open_image
  end

end
