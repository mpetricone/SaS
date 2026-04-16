module EmployeesHelper
  #This handles nil values of employee in a view
  #Returns a tuple(array) with user and a path usable in "link_to"
  #There's probably a batter way to do this
  def get_employee_data obj
    if obj.employee ==nil
      # the javascript seems to be the most reliable way to do nothing from a default link_to
      [ t(:no_user), "javascript:void(0);"]
    else 
      [ obj.employee.user_name, obj.employee ]
    end
  end
end
