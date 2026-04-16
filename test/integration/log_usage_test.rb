require "test_helper"

class LogUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  def visit_logs_page
    visit logs_path
  end

  test "can administer logs" do
    visit_logs_page

    assert_current_path logs_path
    
    assert has_content? "Audit Logs"
    assert has_content? "Module name"

    first("tbody tr td a").click
    assert has_content? "Audit Log for"

    if page.has_link?("ack")
      page.click_link("ack")
      assert has_content? "Updated"
    end

  end

end
