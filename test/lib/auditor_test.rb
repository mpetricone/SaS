require "test_helper"

# Auditor#auto_log runs as a before_action in ApplicationController, so every
# request through every controller should leave a Log row. These tests use the
# already-installed ProductsController as a representative entry point.
class AuditorTest < ActionController::TestCase
  tests ProductsController

  setup do
    @admin = employees(:admin)
    log_in @admin
    Log.delete_all
  end

  test "auto_log writes a row for every authenticated request" do
    get :index
    assert_equal 1, Log.count
    row = Log.last
    assert_equal "ProductsController", row.module_name
    assert_equal "index",              row.in_method
    assert_equal "GET",                row.command
    assert_equal @admin.id,            row.employee_id
  end

  test "auto_log redacts sensitive params" do
    Log.delete_all
    post :create, params: { product: { name: "test product", price: 1, description: "x", password: "shhh", token: "secret" } }
    row = Log.last
    refute_nil row
    refute_includes row.details.to_s, "shhh"
    refute_includes row.details.to_s, "secret"
    assert_includes row.details.to_s, "FILTERED"
  end

  test "auto_log records nil employee for unauthenticated requests" do
    log_out
    Log.delete_all
    get :index
    row = Log.last
    refute_nil row
    assert_nil row.employee_id
  end
end
