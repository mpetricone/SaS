require "test_helper"

class OuPaymentUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test 'can use ou payment type' do
    visit ou_payment_types_path
    assert_current_path ou_payment_types_path

    click_link 'New Ou Payment Type'
    assert_current_path /\/ou_payment_types\/new$/
    fill_in 'ou_payment_type_name', with: 'a thing'
    fill_in 'Method', with: 'a method'
    fill_in 'Date enabled', with: Time.now.strftime(@@date_format)
    fill_in 'ou_payment_type_info', with: 'Some information about this payment method'
    click_button 'Save'
    assert_current_path /\/ou_payment_types\/[0-9]*$/
    assert has_content? 'Ou payment type was successfully created.'
    dismiss_notice
    click_link 'Return'
    first('a', text: 'Edit').click
    assert_current_path /\/ou_payment_types\/[0-9]*\/edit$/
    click_button 'Save'
    assert_current_path /\/ou_payment_types\/[0-9]*$/
    assert has_content? 'Ou payment type was successfully updated.'
    click_link 'Return'
    first('a', text: 'Show').click
    assert_current_path /\/ou_payment_types\/[0-9]*$/
    click_link 'Return'
    first('a', text: 'Delete').click
    accept_alert 'Remove Ou Payment Type'
    assert page.has_content? 'Ou payment type was successfully destroyed.'
  end

  test "cannot create blank ou payment type" do
    visit ou_payment_types_path

    click_link 'New Ou Payment Type'
    click_button 'Save'
    assert_current_path /\/ou_payment_types\/new$/
    assert has_content? "3 Issues preventing Ou Payment Type from being created."
    assert has_content? "Method can't be blank"
    assert has_content? "Name can't be blank"
    assert has_content? "Date enabled can't be blank"
  end
end
