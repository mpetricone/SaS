require "test_helper"

class UserLogonTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "user_logon" do
    logout_user
    visit("/")
    assert page.has_content?('SaS')
    assert page.has_link?('Login')
    click_link('Login')
    page.assert_current_path '/login' 
    assert page.has_content? 'User name' 
    assert page.has_content? 'Password' 
    # Wrong logon
    page.fill_in 'session[user_name]', with: 'Admin'
    page.fill_in 'session[password]', with: 'testtestwrong'
    assert page.has_content? 'User name'
    assert page.has_content? 'Password'
    # right logon
    page.fill_in 'session[user_name]', with: 'Admin'
    page.fill_in 'session[password]', with: 'testtest'
    page.click_button 'Login'
    page.assert_current_path '/' 
    assert page.has_content? 'Tickets'
    assert page.has_content? 'open tickets'
  end
end
