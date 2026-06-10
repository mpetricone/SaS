require "test_helper"

class EmployeePolicyTest < ActiveSupport::TestCase
  setup do
    @admin   = employees(:admin)
    @useless = employees(:useless)
    admin_perm = Permission.find_or_create_by!(name: "Admin") do |p|
      p.object_name = "all"
      p.admin       = true
    end
    EmployeePermission.find_or_create_by!(employee: @admin, permission: admin_perm)
  end

  test "unlock? requires admin" do
    assert EmployeePolicy.new(@admin, Employee).unlock?
    refute EmployeePolicy.new(@useless, Employee).unlock?
    refute EmployeePolicy.new(nil, Employee).unlock?
  end
end
