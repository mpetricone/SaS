class EmployeePolicy < ApplicationPolicy
  permission_name :employee

  def unlock? = admin?
end
