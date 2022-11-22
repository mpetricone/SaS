require "test_helper"

class TaxUsageTest < ActionDispatch::IntegrationTest
  def setup 
    logon_admin
  end

  test "can use taxes" do
    visit taxes_path
    page.assert_current_path taxes_path

    click_link 'New Tax'
    page.assert_current_path /\/taxes\/new/
    assert page.has_content? 'New Tax'
    fill_in "Name", with: 'a name'
    fill_in "Rate", with: '6.3' #this is actually VAtax%
    fill_in 'Region', with: 'TX'
    fill_in 'Date enabled', with: Time.now.strftime(@@date_format)
    click_button 'Save'
    page.assert_current_path taxes_path
    assert page.has_content? /#{Tax.model_name.human} #{Tax.human_attribute_name :rate} .* added.$/
    first('a', text: 'Edit').click
    page.assert_current_path /\/taxes\/[0-9]*\/edit$/
    assert page.has_content? 'Editing Tax'
    fill_in 'Date retired', with: Time.now.strftime(@@date_format)
    click_button 'Save'
    page.assert_current_path /\/taxes\/[0-9]*$/
    assert page.has_content? /Tax .*/
    dismiss_notice
    click_link 'Return'
    page.assert_current_path taxes_path
    first('a', text: 'Show').click
    page.assert_current_path /\/taxes\/[0-9]*$/
    click_link 'Return'
    first('a', text: 'Delete').click
    accept_alert /Really delete Tax .*\? This could cause irreperable damage./
    assert page.has_content? /#{Tax.model_name.human} .* remove.$/
  end
  
  test "cannot create tax with missing data" do
    visit taxes_path

    click_link 'New Tax'
    click_button 'Save'

    assert_current_path /\/taxes\/new$/
    assert has_content? "3 Issues preventing Tax from being created."
    assert has_content? "Rate can't be blank"
    assert has_content? "Name can't be blank"
    assert has_content? "Region can't be blank"
  end

end
