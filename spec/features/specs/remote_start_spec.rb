require 'pry'

require 'spec_helper'

feature 'Hyundai BlueLink - Remote Start', type: :feature, js: true do

  scenario 'logging into Hyundai BlueLink and remote starting the car' do
    home_page.load

    binding.pry

  end

end
