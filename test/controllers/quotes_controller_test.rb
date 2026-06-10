require 'test_helper'

class QuotesControllerTest < ActionController::TestCase
  def setup
    @quote = quotes(:draft_quote)
    logon_admin
  end

  def teardown
    logout_admin
  end

  test 'index renders' do
    get :index
    assert_response :success
  end

  test 'search_by_name filters quotes by client name' do
    target_client = @quote.client
    get :search_by_name, params: { search_name: target_client.name }
    assert_response :success
    found = assigns(:quotes)
    assert_includes found.map(&:client_id), target_client.id
    other_clients = Quote.where.not(client_id: target_client.id).pluck(:client_id).uniq
    assert (found.map(&:client_id) & other_clients).empty?,
           'search should return only quotes for the matched client'
  end

  test 'search_by_name with no match returns empty result' do
    get :search_by_name, params: { search_name: 'xyzzy-no-such-client' }
    assert_response :success
    assert_empty assigns(:quotes)
  end

  test 'show renders' do
    get :show, params: { id: @quote }
    assert_response :success
  end

  test 'show flips a past-due draft to expired' do
    @quote.update_columns(expires_at: 1.day.ago)
    get :show, params: { id: @quote }
    assert_response :success
    assert @quote.reload.expired?
  end

  test 'new renders' do
    get :new
    assert_response :success
  end

  test 'create persists a quote' do
    assert_difference 'Quote.count' do
      post :create, params: { quote: {
        client_id: clients(:client_5).id,
        ou_id:     ous(:ou_5).id,
        rate_id:   rates(:rate_5).id,
        title:     'new from test'
      } }
    end
    assert_redirected_to quote_path(assigns(:quote))
  end

  test 'edit on draft quote renders' do
    get :edit, params: { id: @quote }
    assert_response :success
  end

  test 'edit on locked quote redirects with alert' do
    accepted = quotes(:accepted_quote)
    get :edit, params: { id: accepted }
    assert_redirected_to quote_path(accepted)
  end

  test 'send_to_client transitions state' do
    patch :send_to_client, params: { id: @quote }
    assert_redirected_to quote_path(@quote)
    assert @quote.reload.sent?
  end

  test 'accept transitions sent -> accepted' do
    sent = quotes(:sent_quote)
    patch :accept, params: { id: sent }
    assert_redirected_to quote_path(sent)
    assert sent.reload.accepted?
  end

  test 'decline transitions sent -> declined' do
    sent = quotes(:sent_quote)
    patch :decline, params: { id: sent }
    assert sent.reload.declined?
  end

  test 'convert_to_ticket creates ticket and completes the quote' do
    accepted = quotes(:accepted_quote)
    assert_difference 'Ticket.count', 1 do
      post :convert_to_ticket, params: { id: accepted }
    end
    accepted.reload
    assert accepted.completed?
    assert accepted.converted_ticket_id.present?
    assert_redirected_to ticket_path(accepted.converted_ticket)
  end

  test 'add_addendum builds a draft addendum' do
    accepted = quotes(:accepted_quote)
    assert_difference 'Quote.count', 1 do
      post :add_addendum, params: { id: accepted }
    end
    addendum = Quote.order(:id).last
    assert addendum.draft?
    assert_equal accepted.id, addendum.parent_quote_id
    assert_redirected_to edit_quote_path(addendum)
  end

  test 'add_addendum refuses on draft quote' do
    assert_no_difference 'Quote.count' do
      post :add_addendum, params: { id: @quote }
    end
    assert_redirected_to quote_path(@quote)
  end

  test 'destroy deletes a draft quote' do
    assert_difference 'Quote.count', -1 do
      delete :destroy, params: { id: @quote }
    end
    assert_redirected_to quotes_path
  end

  test 'destroy on locked quote redirects without deleting' do
    accepted = quotes(:accepted_quote)
    assert_no_difference 'Quote.count' do
      delete :destroy, params: { id: accepted }
    end
    assert_redirected_to quote_path(accepted)
  end

  test 'print_view renders without internal sections' do
    get :print_view, params: { id: @quote }
    assert_response :success
    assert_not_includes @response.body, 'Originating Quotes'
    assert_not_includes @response.body, 'Associated Tickets'
  end

  test 'mail_to_client builds the candidate list excluding unauthorized contacts' do
    client = clients(:client_0)
    # Wipe and rebuild contact/email state for deterministic assertions.
    ClientContact.where(client: client).destroy_all
    ClientEmail.where(client: client).destroy_all

    authorized = contacts(:contact_0)
    unauthorized = contacts(:contact_1)
    ClientContact.create!(client: client, contact: authorized, receives_quotes: true)
    ClientContact.create!(client: client, contact: unauthorized, receives_quotes: false)
    ContactEmail.where(contact: authorized).destroy_all
    ContactEmail.where(contact: unauthorized).destroy_all
    ContactEmail.create!(contact: authorized,   address: 'ok@example.com')
    ContactEmail.create!(contact: unauthorized, address: 'nope@example.com')
    ClientEmail.create!(client: client, email: 'billing@example.com')

    get :mail_to_client, params: { id: @quote }
    assert_response :success
    assert_includes @response.body, 'billing@example.com'
    assert_includes @response.body, 'ok@example.com'
    assert_not_includes @response.body, 'nope@example.com'
  end

  test 'mail_to_client_send delivers and transitions a draft' do
    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      post :mail_to_client_send, params: {
        id: @quote,
        mail_to: ['a@example.com', 'b@example.com'],
        extra_email: 'c@example.com'
      }
    end
    delivery = ActionMailer::Base.deliveries.last
    assert_equal ['a@example.com', 'b@example.com', 'c@example.com'].sort, delivery.to.sort
    assert @quote.reload.sent?
    assert_redirected_to quote_path(@quote)
  end

  test 'mail_to_client_send with no recipients re-renders form without sending' do
    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      post :mail_to_client_send, params: { id: @quote, mail_to: [], extra_email: '' }
    end
    assert_response :unprocessable_content
  end
end
