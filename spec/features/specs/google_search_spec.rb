require 'pry'

require 'spec_helper'

feature 'Google - Search', type: :feature, js: true do

  scenario 'visiting the Google home page and searching for the word "capybara"' do
    @home = Pages::Home.new
    @home.load

    @home.search_for(text: 'capybara')

    expect(@home).to have_content 'Capybara - Wikipedia, the free encyclopedia'
  end

end
