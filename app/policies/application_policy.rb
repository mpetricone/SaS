# Hybrid Pundit base policy:
# * Code-shape (one class per resource, action-based methods)
# * DB-backed data (delegates to existing Permission / EmployeePermission rows)
# * Admin bypass (Employee#admin? grants everything)
#
# Each subclass declares a permission name (matching Permission#object_name in
# the DB). The default CRUD action methods route through read?/write?/create?/
# delete?, which look up the permission row.
class ApplicationPolicy
  attr_reader :employee, :record

  def initialize(employee, record)
    @employee = employee
    @record   = record
  end

  # Subclasses override either by calling `permission_name :foo` or by setting
  # the constant directly. nil = no DB lookup, only admin? wins.
  def self.permission_name(name = nil)
    @permission_name = name if name
    @permission_name
  end

  # Default action methods. Override in subclass for unusual actions.
  def admin?            = !!employee&.admin?
  def index?            = read?
  def show?             = read?
  def search_by_name?   = read?
  def new?              = create?
  def edit?             = write?
  def update?           = write?
  def create?           = permitted?(:create_record)
  def destroy?          = permitted?(:delete_record)

  # Bucket helpers.
  def read?   = permitted?(:read_record)
  def write?  = permitted?(:write_record)
  def delete? = permitted?(:delete_record)

  # Always allow the scope of a generic listing through; specific scoping can
  # be added per policy.
  class Scope
    attr_reader :employee, :scope
    def initialize(employee, scope)
      @employee = employee
      @scope    = scope
    end

    def resolve
      scope.all
    end
  end

  protected

  def permitted?(flag, name: self.class.permission_name)
    return false unless employee
    return true  if admin?
    return false unless name
    employee.employee_permissions.any? do |ep|
      perm = ep.permission
      next false unless perm
      perm.object_name == name.to_s && perm.public_send(flag)
    end
  end
end
