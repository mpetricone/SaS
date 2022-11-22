# Login controller, now with tokens
# This should be in lib or vender, but I made it a helper long ago
module SessionsHelper

  def log_in employee
    # this will effectually log out all other instances
    old_auth =  AuthenticityToken.where(employee: employee)
    if (old_auth) 
      old_auth.delete_all
    end
    auth = AuthenticityToken.generate employee
    auth.save
    session[:token] = auth.token;
  end

  def resolve_token
    return session.has_key?(:token) ? session[:token] : params[:token]
  end

  def current_employee
    begin
      @current_employee = AuthenticityToken.find_by(token: resolve_token).employee
    rescue NoMethodError
      @current_emplyee = nil
    end
  end

  def logged_in
    begin
      AuthenticityToken.find_by!(token: resolve_token)
    rescue ActiveRecord::RecordNotFound
      return false
    end
    return true
  end

  def log_out
    auth = AuthenticityToken.find_by(token: resolve_token)
    session.has_key?(:token) ? session.delete(:token) : nil
    @current_employee = nil
    auth.delete
  end

  def has_permission object_name, permission
    @object_name = object_name
    @permission = permission
    if logged_in
      current_employee.employee_permissions.each do |perm|
        if (perm.permission.object_name ==object_name.to_s && perm.permission[permission]) || perm.permission[:admin]
          return :permit
        end
      end
      return :no_perm
    end
    return :login
  end

  def has_write_permission object_name
    has_permission object_name, :write_record
  end
  def has_read_permission object_name
    has_permission object_name, :read_record
  end
  def has_create_permission object_name
    has_permission object_name, :create_record
  end
  def has_delete_permission object_name
    has_permission object_name, :delete_record
  end

  def process_permission perm_result
    case perm_result
    when :login
      flash[:security] = "You must be logged in to perform this action."
      redirect_to login_path
=begin
      respond_to do |f|
        f.html { redirect_to login_path }
        f.json { render json: { response: 'failure', reason: 'You must be logged in to perform this action.' } }
      end
=end
    when :permit
      return true
    when :no_perm
      flash[:security] = "Permission #{@object_name} #{@permission.to_s.humanize} denied for #{current_employee.contact.full_name}."
      respond_to do |f|
        f.html { redirect_to home_index_path }
        f.json { render json: { response: 'failure', reason: 'Permission Denied.' } }
      end
    end
  end

end
