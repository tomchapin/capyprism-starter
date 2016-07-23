module Pages
  class Home < SitePrism::Page
    set_url "/"

    element :search_field, 'input[title="Search"]'
    element :search_button, 'button[value="Search"]'

    # -------------------------------------------
    # Getter methods
    # -------------------------------------------

    # -------------------------------------------
    # Action items
    # -------------------------------------------

    def search_for(text: '')
      search_field.set(text)
      search_button.click
    end

    # -------------------------------------------
    # Validation methods
    # -------------------------------------------

  end
end
