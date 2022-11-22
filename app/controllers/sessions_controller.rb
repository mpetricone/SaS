class SessionsController < ApplicationController
  def new
    respond_to do |f|
      f.html { }
    end
  end

  def create
    employee = Employee.find_by( user_name: params[:session][:user_name].downcase)
    respond_to do |f|
      if (employee && employee.authenticate(params[:session][:password]))
        log_in( employee )
        f.html { redirect_to root_url, notice: "#{employee.contact.full_name} logged in."}
        ret_employee = employee.clone();
        ret_employee.password_digest = nil;
        f.json { render json: { response: "success", token: session[:token], user: employee  } }
      else
        f.html {
          flash.now[:alert] =  "Wrong username or password"
          render :new, status: :unprocessable_entity 
        }
        f.json { render json: { response: "fail" } }
      end
    end
  end

  def destroy
    log_out
    respond_to do |f|
      f.html { redirect_to root_url , notice: "Logged out." }
      f.json { render json: { response: "success" } }
    end
  end
end
