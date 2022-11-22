require "test_helper"

class WorkTypesUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test "work type usage test" do
    visit work_types_path
    assert_current_path work_types_path

    click_link 'New Work Type'
    assert_current_path /\/work_types\/new$/
    fill_in 'work_type_name', with: 'WE USE CAPS HERE YARG'
    click_button 'Save'
    assert_current_path work_types_path
    assert has_content? /#{WorkType.model_name.human} .* added\.$/
    first('a', text: 'Show').click
    assert_current_path /\/work_types\/[0-9]*$/
    click_link 'Return'
    first('a', text: 'Edit').click
    assert_current_path /\/work_types\/[0-9]*\/edit$/
    click_button 'Save'
    assert_current_path work_types_path
    assert has_content? /#{WorkType.model_name.human} .* altered\.$/
    first('a', text: 'Delete').click
    accept_alert /Really delete Work Type .*\?$/
    assert has_content? "#{WorkType.model_name.human} removed."
  end
end
