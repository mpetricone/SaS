require "test_helper"

class AuditTest < ActiveSupport::TestCase
  setup do
    @employee = employees(:admin)
    Log.delete_all
  end

  test "event writes a row with the expected fields" do
    fake_request = Struct.new(:remote_ip, :user_agent, :request_method)
                         .new("9.9.9.9", "TestUA/1", "POST")
    Audit.event(:login_success, employee: @employee, request: fake_request, details: { extra: "x" })

    row = Log.last
    refute_nil row
    assert_equal "security",         row.category
    assert_equal "Audit",             row.module_name
    assert_equal "login_success",     row.in_method
    assert_equal "POST",              row.command
    assert_equal @employee.id,        row.employee_id
    parsed = JSON.parse(row.details)
    assert_equal "9.9.9.9", parsed["ip"]
    assert_equal "TestUA/1", parsed["user_agent"]
    assert_equal "x",        parsed["extra"]
  end

  test "event without a request still writes a row (e.g. rake context)" do
    Audit.event(:admin_granted, employee: @employee, details: { granted_via: "rake" })
    row = Log.last
    assert_equal "INTERNAL", row.command
    assert_equal "admin_granted", row.in_method
    assert_equal @employee.id, row.employee_id
  end

  test "event without an employee writes a row with nil employee_id" do
    fake_request = Struct.new(:remote_ip, :user_agent, :request_method).new("1.1.1.1", "x", "POST")
    Audit.event(:login_failure, request: fake_request, details: { user_name_attempted: "ghost" })
    row = Log.last
    assert_nil row.employee_id
    assert_equal "login_failure", row.in_method
    assert_equal "ghost", JSON.parse(row.details)["user_name_attempted"]
  end

  test "unknown event names raise so typos surface" do
    assert_raises(ArgumentError) do
      Audit.event(:misspelt_event, employee: @employee)
    end
  end
end
