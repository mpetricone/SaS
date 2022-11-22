require "test_helper"

class TicketPicturesControllerTest < ActionController::TestCase
  def setup
    @ticket_picture = ticket_pictures(:ticket_picture_1_1)
    @ticket = tickets(:ticket_1)
    logon_admin
  end

  def teardown
    logout_admin
  end

  def create_params
    {
      ticket_id: @ticket.id,
      id: @ticket_picture.id,
      ticket_picture: {
        description: @ticket_picture.description,
        taken_at: @ticket_picture.taken_at,
        note: @ticket_picture.note,
        image: fixture_file_upload("tp.png", "image/png")
      }
    }
  end

  test "should get new" do
    @ticket.ticket_pictures
    get :new, params: { ticket_id: @ticket.id }
    assert_response :success
  end

  test "should create ticket_picture" do
    assert_difference("TicketPicture.count") do
      post :create, params: create_params
    end

    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should get edit" do
    get :edit, params: {
                 ticket_id: @ticket.id,
                 id: @ticket_picture.id
               }

    assert_response :success
  end

  test "should update ticket_picture" do
    patch :update, params: create_params

    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should destroy ticket_picture" do
    assert_difference("TicketPicture.count", -1) do
      delete :destroy, params: {
                         ticket_id: @ticket.id,
                         id: @ticket_picture.id,
                       }
    end

    assert_redirected_to ticket_path(assigns(:ticket))
  end
end
