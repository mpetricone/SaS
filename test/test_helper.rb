ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require File.expand_path "app/helpers/sessions_helper"

Minitest.after_run do
  puts "Cleaning up test storage..."
  FileUtils.rm_rf(ActiveStorage::Blob.services.fetch(:test).root)
  puts "Cleanup complete."
end

class ActiveSupport::TestCase
  include SessionsHelper
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def logon_admin
    log_in Employee.find_by(user_name: "Admin")
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
require "capybara/apparition"

class ActionDispatch::IntegrationTest
  # I18n.t l helper
  # finally figured this out, why isn't it just automatic?
  include ActionView::Helpers::TranslationHelper

  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  # Wait timer
  # date format string for Time::strftime
  @@date_format = "%m%d%Y"

  setup do
    Capybara.server = :webrick
    # Capybara.register_driver :selenium_chrome
    Capybara.default_driver = :selenium_chrome
    page.driver.browser.manage.window.resize_to(1024, 1080)
    Capybara.default_max_wait_time = 5
  end

  # Reset sessions and driver between tests
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
    page.fill_in "session[password]", with: REMOVED
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
