class EmployeePermission < ActiveRecord::Base
    belongs_to :employee
    belongs_to :permission
end
