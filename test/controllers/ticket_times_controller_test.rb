require 'test_helper'

class TicketTimesControllerTest < ActionController::TestCase
	def setup
		@ticket_time = ticket_times(:ticket_time_1_1)
		@ticket = tickets(:ticket_1)
		logon_admin
	end

	def teardown
		logout_admin
	end

  test 'should not access page' do
    should_not_access_data @ticket_time, update_params, [:index, :show],
      {
        id: @ticket_time,
        ticket_id: @ticket
      }
  end

	test 'should get new' do
		get :new, params: { ticket_id: @ticket_time.ticket.id }
		assert_response :success
	end

	def create_params
		{
			ticket_id: @ticket.id,
			ticket_time: {
				date: @ticket_time.date,
				time_start: @ticket_time.time_start,
				time_end: @ticket_time.time_end,
				hours: @ticket_time.hours
			}
		}
	end

	test 'should create ticket_time' do
		assert_difference('TicketTime.count') do
			post :create, params: create_params
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should create ticket_time returning json' do
		assert_difference('TicketTime.count') do
			post :create, params: create_params, format: :json
		end

		assert_json_success
	end

  test 'should get edit' do
    get :edit, params: { ticket_id: @ticket_time.ticket.id, id: @ticket_time }
    assert_response :success
  end

	def update_params
		{
			ticket_id: @ticket_time.ticket.id,
			id: @ticket_time,
			ticket_time: { hours: @ticket_time.hours }
		}
	end

	test 'should update ticket_time' do
		patch :update, params: update_params
		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should update ticket_time returning json' do
		patch :update, params: update_params, format: :json
		assert_json_success
	end

	test 'should destroy ticket_time' do
		assert_difference('TicketTime.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_time }
		end

		assert_redirected_to ticket_path(assigns(:ticket))
	end

	test 'should destroy ticket_time returning json' do
		assert_difference('TicketTime.count', -1) do
			delete :destroy, params: { ticket_id: @ticket.id, id: @ticket_time }, format: :json
		end

		assert_json_success
	end

  test 'should start timer' do
    assert_difference('TicketTime.count') do
      post :start, params: { ticket_id: @ticket.id }, format: :json
    end
    assert_response :success
    body = JSON.parse(response.body)
    assert body['id'].present?
    assert body['timer_started_at'].present?
    assert TicketTime.find(body['id']).running
  end

  test 'start timer returns conflict when timer already running for employee' do
    post :start, params: { ticket_id: @ticket.id }, format: :json
    assert_response :success
    post :start, params: { ticket_id: @ticket.id }, format: :json
    assert_response :conflict
  end

  test 'start timer returns unprocessable when ticket is invoiced' do
    @ticket.update!(payment_requested: true)
    post :start, params: { ticket_id: @ticket.id }, format: :json
    assert_response :unprocessable_entity
  end

  test 'should stop running timer' do
    running = @ticket.ticket_times.create!(
      running: true,
      timer_started_at: 1.hour.ago,
      employee: employees(:admin)
    )
    patch :stop, params: { ticket_id: @ticket.id, id: running.id }, format: :json
    assert_json_success
    running.reload
    assert_equal false, running.running
  end

  test 'stop timer redirects html to ticket' do
    running = @ticket.ticket_times.create!(
      running: true,
      timer_started_at: 1.hour.ago,
      employee: employees(:admin)
    )
    patch :stop, params: { ticket_id: @ticket.id, id: running.id }
    assert_redirected_to ticket_path(@ticket)
  end

  test 'should resume a stopped timer' do
    stopped = @ticket.ticket_times.create!(
      running: false,
      timer_started_at: 2.hours.ago,
      timer_stopped_at: 1.hour.ago,
      employee: employees(:admin)
    )
    patch :resume, params: { ticket_id: @ticket.id, id: stopped.id }, format: :json
    assert_response :success
    body = JSON.parse(response.body)
    assert body['id'].present?
    assert body['timer_started_at'].present?
    stopped.reload
    assert stopped.running
    assert_nil stopped.timer_stopped_at
  end

  test 'resume returns conflict when another timer already running for employee' do
    @ticket.ticket_times.create!(
      running: true,
      timer_started_at: 1.hour.ago,
      employee: employees(:admin)
    )
    stopped = @ticket.ticket_times.create!(
      running: false,
      timer_started_at: 3.hours.ago,
      timer_stopped_at: 2.hours.ago,
      employee: employees(:admin)
    )
    patch :resume, params: { ticket_id: @ticket.id, id: stopped.id }, format: :json
    assert_response :conflict
  end

  test 'resume returns unprocessable when ticket is invoiced' do
    @ticket.update!(payment_requested: true)
    stopped = @ticket.ticket_times.create!(
      running: false,
      timer_started_at: 2.hours.ago,
      timer_stopped_at: 1.hour.ago,
      employee: employees(:admin)
    )
    patch :resume, params: { ticket_id: @ticket.id, id: stopped.id }, format: :json
    assert_response :unprocessable_entity
  end

  test 'start timer returns unprocessable when ticket is closed' do
    @ticket.update!(ticket_status: ticket_statuses(:ticket_solved))
    post :start, params: { ticket_id: @ticket.id }, format: :json
    assert_response :unprocessable_entity
  end
end
