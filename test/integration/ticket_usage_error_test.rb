require "test_helper"
require "support/ticket_integration_test_helper"

class TicketUsageErrorTest < ActionDispatch::IntegrationTest
  include TicketIntegrationTestHelper

  def setup 
    logon_admin
  end

  test 'cannot create missing product' do
    get_ticket_view
    click_link 'Add Product'
    click_button 'Save'
    assert_current_path /\/tickets\/[0-9]*\/product_tickets\/new$/
    assert has_content? 'Product must exist'
  end

  test 'cannot create expense without cost' do
    get_ticket_view
    click_link 'Add Ticket Expense'
    assert_current_path /\/tickets\/[0-9]*\/ticket_expenses\/new$/
    click_button 'Save'
    assert has_content? "Cost can't be blank"
  end
end
