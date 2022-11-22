require "test_helper"

class StandingUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test "can use standing" do
    visit standings_path
    page.assert_current_path standings_path

    click_link 'New Standing'
    page.assert_current_path /\/standings\/new$/
    assert has_content? 'New Standing'
    fill_in 'standing_name', with: 'std name'
    click_button 'Save'
    page.assert_current_path standings_path
    assert has_content? 'Standing was successfully created.'
    first('a', text: 'Edit').click
    assert_current_path /\/standings\/[0-9]*\/edit$/
    click_button 'Save'
    page.assert_current_path standings_path
    assert has_content? 'Standing was successfully updated.'
    first('a', text: 'Show').click
    assert_current_path /\/standings\/[0-9]*$/
    click_link 'Return'
    assert_current_path standings_path
    first('a', text: 'Delete').click
    accept_alert /Really delete Standing .*\?/
    assert has_content? 'Standing was successfully destroyed.'
  end
end
