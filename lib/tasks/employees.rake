namespace :employees do
  desc "Grant the admin permission to an employee by user_name. Run via: docker compose exec web bundle exec rails employees:grant_admin[username]"
  task :grant_admin, [:user_name] => :environment do |_, args|
    name = args[:user_name].to_s.strip.downcase
    abort("Usage: rails employees:grant_admin[user_name]") if name.empty?

    employee = Employee.find_by(user_name: name)
    abort("No employee with user_name=#{name.inspect}") unless employee

    admin_perm = Permission.find_or_create_by!(name: "Admin") do |p|
      p.object_name    = "all"
      p.admin          = true
      p.read_record    = true
      p.write_record   = true
      p.create_record  = true
      p.delete_record  = true
    end

    EmployeePermission.find_or_create_by!(employee: employee, permission: admin_perm)
    employee.unlock!
    Audit.event(:admin_granted, employee: employee, details: { granted_via: "rake" })
    puts "Granted Admin permission to #{employee.user_name} (id=#{employee.id})."
  end

  desc "Unlock a locked employee account. Run via: docker compose exec web bundle exec rails employees:unlock[username]"
  task :unlock, [:user_name] => :environment do |_, args|
    name = args[:user_name].to_s.strip.downcase
    abort("Usage: rails employees:unlock[user_name]") if name.empty?

    employee = Employee.find_by(user_name: name)
    abort("No employee with user_name=#{name.inspect}") unless employee
    employee.unlock!
    puts "Unlocked #{employee.user_name}."
  end
end
