module OuIntegrationTestHelper
    def visit_ou_page
        visit ous_path
      end
    
      def find_ou_details
        visit ous_path
        first('a',text: 'Show').click
      end
end