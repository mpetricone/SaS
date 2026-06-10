require "test_helper"

# Verifies the Rack::Attack login throttle. The initializer disables
# Rack::Attack in test env by default; we re-enable it for this test and
# clear the cache so counters don't leak between examples.
class RackAttackTest < ActionDispatch::IntegrationTest
  setup do
    Rack::Attack.enabled = true
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  teardown do
    Rack::Attack.enabled = false
    # Each pass through SessionsController#create with a bad password increments
    # failed_attempts on the matching employee. Without this cleanup, the Admin
    # user gets locked and every subsequent integration test fails to log in.
    employees(:admin).unlock!
  end

  test "login is throttled after 5 attempts per IP" do
    6.times do |i|
      post session_url,
        params: { session: { user_name: "Admin", password: "wrong#{i}" } },
        env:    { "REMOTE_ADDR" => "5.5.5.5" }
    end
    assert_equal 429, response.status, "expected the 6th request to be throttled"
  end

  test "the per-username throttle protects against distributed-IP guessing" do
    6.times do |i|
      post session_url,
        params: { session: { user_name: "Admin", password: "wrong" } },
        env:    { "REMOTE_ADDR" => "10.0.0.#{i + 1}" }
    end
    assert_equal 429, response.status, "expected per-username throttle to engage"
  end
end
