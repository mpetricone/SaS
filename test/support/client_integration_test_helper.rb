module ClientIntegrationTestHelper
    def find_client
        visit clients_path
    
        first("tbody tr").click_link 'Show'
      end
    
      def find_client_details
        find_client
    
        click_link 'Client Details'
      end

      def visit_new_client 
        visit clients_path

        click_link 'New Client'
      end
end