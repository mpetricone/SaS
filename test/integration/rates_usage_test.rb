require "test_helper"

class RatesUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  def visit_rates_page
    visit rates_path
  end

  def find_rate_details
    first('a', "Show").click
  end

  wp = /\/rates\/[0-9]*/

  test "can create and use rate" do
    visit_rates_page

    page.assert_current_path rates_path
    click_link 'New Rate'
    assert page.has_content? "New Rate"
    fill_in 'Rate', with: '100.00'
    check 'Current'
    fill_in 'Date implemented', with: Time.now.strftime(@@date_format)
    fill_in 'Date retired', with: Time.now.to_date.next_year.strftime(@@date_format)
    click_button 'Save'
    page.assert_current_path wp
    assert page.has_content? 'Rate was successfully created.'
    dismiss_notice
    first('a',text: 'Edit').click
    page.assert_current_path /\/rates\/[0-9]*\/edit$/
    assert page.has_content? 'Editing Rate'
    click_button 'Save'
    page.assert_current_path wp
    assert page.has_content? 'Rate was successfully updated.'
    click_link 'Return'
    page.assert_current_path rates_path
    first('a', text: 'Delete').click
    accept_alert /Really delete Rate .*\?$/
    assert page.has_content? 'Rate was successfully destroyed.'
    first('a', text: 'Show').click
    page.assert_current_path /\/rates\/[0-9]*$/
  end

  test "cannot create blank rate" do
    visit_rates_page

    click_link 'New Rate'
    click_button 'Save'

    assert_current_path /\/rates\/new$/
    assert has_content? "1 Issue preventing Rate from being created."
    assert has_content? "Rate can't be blank"
  end

end
