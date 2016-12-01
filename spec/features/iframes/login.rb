module Iframes
  class Login < SitePrism::Page

    element :email_input, 'input[name=Email]'

    # -------------------------------------------
    # Getter methods
    # -------------------------------------------

    # -------------------------------------------
    # Action items
    # -------------------------------------------
    def login(email_address: '', password: '')
      binding.pry
    end


    # -------------------------------------------
    # Validation methods
    # -------------------------------------------

  end
end