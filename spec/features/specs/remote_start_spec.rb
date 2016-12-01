require 'pry'

require 'spec_helper'

feature 'Hyundai BlueLink - Remote Start', type: :feature, js: true do

  scenario 'logging into Hyundai BlueLink and remote starting the car' do
    home_page.load

    home_page.login(email_address: ENV['HYUNDAI_USERNAME'], password: ENV['HYUNDAI_PASSWORD'])

    # Wait for the log in process to complete and for the VIN to show on the dashboard
    page.should have_content(ENV['HYUNDAI_VIN'])

    binding.pry

  end

end
