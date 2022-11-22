require "test_helper"

class AboutTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test "can visit about page" do
    click_link 'Help'
    click_link 'About'
    assert has_content? "About Sales and Services"
  end
end
