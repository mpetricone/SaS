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
    assert has_content? /Added #{WorkType.model_name.human}/
    click_link 'Show', match: :first
    assert_current_path /\/work_types\/[0-9]*$/
    click_link 'Return'
    click_link 'Edit', match: :first
    assert_current_path /\/work_types\/[0-9]*\/edit$/
    click_button 'Save'
    assert_current_path work_types_path
    assert has_content? /Updated #{WorkType.model_name.human}/
    click_link 'Delete', match: :first
    accept_alert /Really delete Work Type .*\?$/
    assert has_content? "Removed #{WorkType.model_name.human}"
  end
end
