class ClientPolicy < ApplicationPolicy
  permission_name :client

  # Legacy behavior: read access for clients flowed off the :contact permission.
  def read?  = permitted?(:read_record, name: :contact)
  def show2? = read?
end
