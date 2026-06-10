class LogPolicy < ApplicationPolicy
  permission_name :auditor

  def ack? = write?
end
