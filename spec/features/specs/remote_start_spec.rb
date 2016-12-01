require 'pry'

require 'spec_helper'

feature 'Hyundai BlueLink - Remote Start', type: :feature, js: true do

  scenario 'logging into Hyundai BlueLink and remote starting the car' do
    puts 'Loading the My Hyundai site'
    home_page.load

    puts 'Logging in'
    home_page.login(email_address: ENV['HYUNDAI_USERNAME'], password: ENV['HYUNDAI_PASSWORD'])

    puts 'Waiting for the log in process to complete and for the VIN to show on the dashboard'
    expect(page).to have_content(ENV['HYUNDAI_VIN'])
  end

end
