require "test_helper"

class TicketsControllerTest < ActionController::TestCase
  def setup
    @ticket = tickets(:ticket_1)
    @tax = taxes(:tax_1)
    @tnt = @ticket
    @tnt.taxable = nil
    @tnt.taxable_labor = nil
    @tnt.tax_exemption = nil
    logon_admin
  end

  def teardown
    logout_admin
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should close ticket" do
    patch :close_ticket, params: { id: @ticket }
    assert_redirected_to tickets_path(assigns(:tickets))
  end

  test "should close ticket returning json" do
    patch :close_ticket, format: :json, params: { id: @ticket }
    assert_json_success
  end

  test "should open ticket" do
    patch :open_ticket, params: { id: @ticket }
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should open ticket returning json" do
    patch :open_ticket, params: { id: @ticket }, format: :json
    assert_json_success
  end

  test "should get index client list" do
    get :index
    assert_response :success
    get :index_client_list, params: { client_name: "client" }, xhr: true
    assert_response :success
    assert assigns(:clients)
  end

  def list_params
    {
      client_id: @ticket.client.id,
      search: { search_solved: true, search_date: false },
    }
  end

  test "should get index ticket list" do
    get :index
    assert_response :success
    get :index_show_list, params: list_params, xhr: true
    assert_response :success
    assert assigns(:client)
    assert assigns(:tickets)
  end

  test "should show list returning json" do
    get :index_show_list, params: list_params, format: :json
    assert_response :success
    assert assigns(:tickets)
  end

  test "should get new" do
    get :new, params: { client_id: @ticket.client_id }
    assert_response :success
  end

  def create_params
    {
      ticket: {
        client_id: @ticket.client.id, contact_id: @ticket.contact.id,
        employee_id: @ticket.employee.id, rate_id: @ticket.rate.id,
        ticket_status_id: @ticket.ticket_status.id,
        cost_parts: @ticket.cost_parts, date_created: @ticket.date_created,
        date_resolved: @ticket.date_resolved,
        short_description: @ticket.short_description,
        billing_hourly: @ticket.billing_hourly,
        billing_fixed: @ticket.billing_fixed,
        billing_fixed_value: @ticket.billing_fixed_value,
        payment_requrest: @ticket.payment_requested,
        payment_received: @ticket.payment_received,
        invoice_date: @ticket.invoice_date,
        default_invoice_id: @ticket.ticket_invoice_address.id,
        default_delivery_id: @ticket.ticket_delivery_address.id,
        ou_address_id: @ticket.employee.ou.id,
        ou_id: @ticket.ou_id, payed_in_full: @ticket.payed_in_full,
        tax: @ticket.tax, tax_rate: @ticket.tax_rate,
        sale_cost: @ticket.sale_cost, taxable: @ticket.taxable,
        taxable_labor: @ticket.taxable_labor,
      }, tax: { selected_tax: @tax.id },
    }
  end

  test "should create ticket" do
    assert_difference("Ticket.count") do
      post :create, params: create_params
    end

    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should create ticket returning json" do
    assert_difference("Ticket.count") do
      post :create, params: create_params, format: :json
    end

    assert_json_success
  end

  test "should show ticket with null tax" do
    get :show,
        params: {
          id: @tnt,
        }
    assert_response :success
  end

  test "should get edit with null tax" do
    get :edit, params: { id: @tnt }
    assert_response :success
  end

  test "should show ticket" do
    get :show, params: { id: @ticket }
    assert_response :success
  end

  test "should get edit" do
    get :edit,
        params: {
          id: @ticket,

        }
    assert_response :success
  end

  def update_params
    {
      id: @ticket,
      ticket: { cost_parts: @ticket.cost_parts },
      tax: { selected_tax: @tax.id },
    }
  end

  test "should update ticket" do
    patch :update, params: update_params
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should update ticket returning json" do
    patch :update, params: update_params, format: :json
    assert_json_success
  end

  test "should destroy ticket" do
    assert_difference("Ticket.count", -1) do
      delete :destroy, params: { id: @ticket }
    end

    assert_redirected_to tickets_path
  end

  test "should destroy ticket returning json" do
    assert_difference("Ticket.count", -1) do
      delete :destroy, params: { id: @ticket }, format: :json
    end

    assert_json_success
  end
end
