require "test_helper"

class CanUseAboutPageTest < ActionDispatch::IntegrationTest
  test "can use about page" do
    visit '/about/index.html'
    assert has_content? 'About Sales and Services'
    assert has_content? 'Version'
  end
end
