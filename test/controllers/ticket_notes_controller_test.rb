require "test_helper"

class TicketNotesControllerTest < ActionController::TestCase
  def setup
    @ticket_note = ticket_notes(:ticket_note_1_1)
    @ticket = tickets(:ticket_1)
    logon_admin
  end

  def teardown
    logout_admin
  end

  test "should get new" do
    get :new, params: { ticket_id: @ticket.id }
    assert_response :success
  end

  test "sould create ticket note" do
    assert_difference("TicketNote.count") do
      post :create, params: create_params
    end

    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should get edit" do
    get :edit, params: { ticket_id: @ticket.id, id: @ticket_note.id }
    assert_response :success
  end

  test "should update ticket note" do
    patch :update, params: {
      ticket_id: @ticket.id,
      id: @ticket_note.id,
      ticket_note: {
        id: @ticket_note.id,
        subject: 'bah',
        body: 'wtf',
      }
    }
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should destroy ticket note" do
    assert_difference("TicketNote.count", -1) do
      delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_note.id }
    end

    assert_redirected_to ticket_path(assigns(:ticket))
  end

  def create_params
    {
      ticket_id: @ticket.id,
      ticket_note: {
        ticket_id: @ticket.id,
        subject: @ticket_note.subject,
        body: @ticket_note.body,
      },
    }
  end
end
