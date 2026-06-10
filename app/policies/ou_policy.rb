class OuPolicy < ApplicationPolicy
  permission_name :ou

  def set_disabled?   = write?
  def clear_disabled? = write?
end
