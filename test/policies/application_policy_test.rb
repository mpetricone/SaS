require "test_helper"

# Exercises the hybrid policy machinery: admin bypass, DB-backed permission
# lookup, and unauth handling. Uses ProductPolicy as a representative subclass.
class ApplicationPolicyTest < ActiveSupport::TestCase
  setup do
    @admin   = employees(:admin)
    @useless = employees(:useless)

    @admin_perm = Permission.find_or_create_by!(name: "Admin") do |p|
      p.object_name   = "all"
      p.admin         = true
      p.create_record = true
      p.read_record   = true
      p.write_record  = true
      p.delete_record = true
    end
    EmployeePermission.find_or_create_by!(employee: @admin, permission: @admin_perm)

    @product_read_perm = Permission.find_or_create_by!(name: "Product reader") do |p|
      p.object_name = "product"
      p.read_record = true
    end
  end

  test "admin? is true when an employee has any admin-flagged permission" do
    assert @admin.admin?
    refute @useless.admin?
  end

  test "admin bypasses every per-resource check" do
    policy = ProductPolicy.new(@admin, Product)
    assert policy.index?
    assert policy.show?
    assert policy.create?
    assert policy.update?
    assert policy.destroy?
  end

  test "a non-admin with the matching read permission can read but not write" do
    EmployeePermission.create!(employee: @useless, permission: @product_read_perm)
    policy = ProductPolicy.new(@useless, Product)
    assert policy.show?
    assert policy.index?
    refute policy.update?
    refute policy.create?
    refute policy.destroy?
  end

  test "a non-admin without the matching permission gets denied everywhere" do
    policy = ProductPolicy.new(@useless, Product)
    refute policy.show?
    refute policy.update?
    refute policy.create?
    refute policy.destroy?
  end

  test "nil employee (unauthenticated) gets denied" do
    policy = ProductPolicy.new(nil, Product)
    refute policy.show?
    refute policy.update?
    refute policy.create?
    refute policy.destroy?
  end
end
