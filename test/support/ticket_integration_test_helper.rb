module TicketIntegrationTestHelper
  def get_tickets_page
    visit tickets_path
    click_link 'Main Menu'
    click_link 'Tickets'
    page.assert_current_path tickets_path
  end

  def search_for_ticket(solved = false)
    get_tickets_page

    check 'search_solved' if solved

    click_button 'Search'
    first('tbody tr a', text: 'client_').click
    page.assert_current_path tickets_path
  end

  def get_ticket_view(solved = false)
    search_for_ticket solved
    first('tbody tr .btn-group a', text: 'Show').click
    assert page.has_content? Ticket.model_name
    page.assert_current_path(%r{tickets/[0-9]*})
  end

end
