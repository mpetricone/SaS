ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"

# Active Storage variant processing can fail silently in tests (missing image
# processor, fixture file not on disk), leaving processed? false so url returns
# nil, and redirect_to(nil) raises ActionControllerError. Capybara then defers
# that server exception to the next test as an E. Return 404 instead so
# Capybara never sees a server-side exception from background image requests.
ActiveStorage::Representations::RedirectController.prepend(Module.new do
  def show
    super
  rescue ActionController::ActionControllerError
    head :not_found
  end
end)

Minitest.after_run do
  puts "Cleaning up test storage..."
  FileUtils.rm_rf(ActiveStorage::Blob.services.fetch(:test).root)
  puts "Cleanup complete."
end

class ActiveSupport::TestCase
  include ActiveJob::TestHelper

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Test-side login: create a Session row, set the signed session_id cookie,
  # and prime Current.session so a controller action behaves as authenticated.
  # Requires the test to have `cookies` available (controller / integration tests).
  def log_in(employee)
    session = employee.sessions.create!(user_agent: "test", ip_address: "127.0.0.1")
    cookies.signed[:session_id] = session.id
    Current.session = session
    session
  end

  def log_out
    if cookies.signed[:session_id]
      Session.find_by(id: cookies.signed[:session_id])&.destroy
      cookies.delete(:session_id)
    end
    Current.session = nil
  end

  def logon_admin
    log_in Employee.find_by(user_name: "Admin")
  end

  def login_useless_user
    log_in Employee.find_by(user_name: 'Useless')
  end

  #test the usual routes for no access
  def should_not_access_data model,params,exclude = [], parent_params={}
    log_out
    login_useless_user

    if !exclude.any?(:index)
      get :index
      assert_redirected_to home_index_path
    end
    if !exclude.any?(:new)
      get :new, params: parent_params
      assert_redirected_to home_index_path
    end
    if !exclude.any?(:create)
      post :create, params: params
      assert_redirected_to home_index_path
    end
    if !exclude.any?(:show)
      get :show, params: params
      assert_redirected_to home_index_path
    end
    if !exclude.any?(:edit)
      get :edit, params: params
      assert_redirected_to home_index_path
    end
    if !exclude.any?(:update)
      patch :update, params: params
      assert_redirected_to home_index_path
    end
  end

  def logout_admin
    log_out
  end

  def assert_json_success
    assert_response :success
    assert_equal "success", JSON.parse(response.body)["response"]
  end
end

# Capybara
require "capybara/rails"
require "capybara/minitest"

Capybara.register_driver :selenium_remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--disable-gpu")
  options.add_argument("--window-size=1200,900")
  options.add_argument("--ignore-certificate-errors")
  options.add_argument("--allow-insecure-localhost")
  options.add_argument("--disable-features=EnableHSTS")
  options.add_argument("--disable-features=UpgradedInsecureRequests")
  options.add_argument("--unsafely-treat-insecure-origin-as-secure=http://app:3001")
  options.add_argument("--ingore-ssl-errors")

  options.accept_insecure_certs = true

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url:     ENV.fetch("SELENIUM_REMOTE_URL", "http://selenium:4444"),
    options: options
  )
end
require "socket"
app_ip =Socket.ip_address_list
           .find { |addr| addr.ipv4? && !addr.ipv4_loopback? }
           .ip_address

Capybara.server_host        = ENV.fetch("CAPYBARA_SERVER_HOST", "0.0.0.0")
Capybara.server_port        = 4567
Capybara.app_host           = "http://#{app_ip}:#{Capybara.server_port}"
Capybara.server = :puma, { Host: "0.0.0.0" }

Rails.application.routes.default_url_options = { host: app_ip, port: Capybara.server_port }

class ActionDispatch::IntegrationTest
  include ActionView::Helpers::TranslationHelper
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  @@date_format = "%m%d%Y"

  setup do
    Capybara.default_driver     = :selenium_remote_chrome
    Capybara.default_max_wait_time = 8
  end

  teardown do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  # login admin from root
  def logon_admin
    logout_user
    visit "/"
    click_link("Login")
    assert page.has_content? "User name"
    assert page.has_content? "Password"
    page.fill_in "session[user_name]", with: "Admin"
    page.fill_in "session[password]", with: "testtest"
    page.click_button "Login"
    page.assert_current_path "/"
  end

  # ensure this is the homepage
  def assert_home_page
    assert page.has_content? "Tickets"
    assert page.has_content? "open tickets"
  end

  # logout admin from link
  def logout_user
    visit "/"
    if page.has_content? "Logout"
      click_link "Logout"
      page.assert_current_path "/"
      assert !page.has_content?("open ticket")
    end
  end

  def dismiss_notice
    begin
      first(".btn-close").click
    rescue StandardError
      # this is ok, element isn't here
    end
  end
end
