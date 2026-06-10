class AccountsReceivablePolicy < ApplicationPolicy
  permission_name :accounting_restricted

  def search? = read?
end
