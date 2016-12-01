module Pages
  class Home < SitePrism::Page
    set_url "/MyHyundai/Home/Dashboard"

    element :search_field, 'input[title="Search"]'
    element :search_button, 'button[value="Search"]'

    # -------------------------------------------
    # Getter methods
    # -------------------------------------------

    # -------------------------------------------
    # Action items
    # -------------------------------------------

    def login(email_address: '', password: '')
      within_frame(find('.myhyundai-lbIframe')) do
        page.find('input[name=Email]').set(email_address)
        page.find('input[name=Password]').set(password)
        page.find('.formSubmit button[type=Submit]').click
      end
    end

    # -------------------------------------------
    # Validation methods
    # -------------------------------------------

  end
end

module PageNameHelpers
  def home_page
    Pages::Home.new
  end
end