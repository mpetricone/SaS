require "test_helper"

class PermissionsUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end

  test "can use permissions" do
    visit permissions_path

    page.assert_current_path permissions_path
    click_link "New Permission"
    page.assert_current_path /\/permissions\/new$/
    assert page.has_content? "New Permission"
    fill_in "permission_name", with: "perm01"
    fill_in "permission_object_name", with: "not a real object"
    check "Read Record"
    check "Write Record"
    check "Create Record"
    check "Delete Record"
    check "permission_admin"
    click_button "Save"
    page.assert_current_path permissions_path
    assert page.has_content? /\ added.$/
    first("a", text: "Edit").click
    page.assert_current_path /\/permissions\/[0-9]*\/edit$/
    assert page.has_content? "Editing Permission"
    click_button "Save"
    page.assert_current_path permissions_path
    assert page.has_content? /\ updated.$/
    first("a", text: "Show").click
    page.assert_current_path /\/permissions\/[0-9]*$/
    click_link "Return"
    assert_current_path permissions_path
    first("a", text: "Delete").click
    accept_alert "Really delete Permission? This could criple the system"
    assert has_content? /#{Permission.model_name.human} .* deleted.$/
  end

  def create_permission
    visit permissions_path
    click_link "New Permission"
    fill_in "permission[name]", with: "will_be_duplicated"
    fill_in "permission[object_name]", with: "object"
    click_button "Save"
  end

  test "cannot create duplicate permission" do
    create_permission
    create_permission
    assert_current_path /\/permissions\/new$/
    assert has_content? "1 Issue preventing Permission from being created."
    assert has_content? "Name has already been taken"
  end
end
