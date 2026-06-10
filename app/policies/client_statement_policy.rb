class ClientStatementPolicy < ApplicationPolicy
  permission_name :client

  def generate? = permitted?(:read_record, name: :accounting_restricted)
end
