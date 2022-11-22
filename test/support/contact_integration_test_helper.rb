module ContactIntegrationTestHelper

  def find_contact 
    visit contacts_path

    first('.table .btn-group').click_link "Show"
  end

end