# Legacy authentication/permission helpers were removed in Phase 6 of the
# auth revamp. Authentication now lives in app/controllers/concerns/authentication.rb
# and authorization is handled by Pundit policies under app/policies/.
module SessionsHelper
end
