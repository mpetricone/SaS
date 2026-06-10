class EmployeePermission < ActiveRecord::Base
  belongs_to :employee
  belongs_to :permission

  validates :permission_id, presence: true
end
