module Pages
   class Home < SitePrism::Page
      set_url "/"

      element :search_field, 'input[title="Search"]'
      element :search_button, 'input[value="Google Search"]'

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

module PageNameHelpers
   def home_page
      Pages::Home.new
   end
end