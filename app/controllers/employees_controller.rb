class EmployeesController < ApplicationController
  before_action(only: [:show, :index, :search_by_name]) { process_permission has_read_permission(:employee) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:employee) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:employee) }
  before_action(only: [:destroy]) { process_permission has_delete_permission(:employee) }

  def index
    respond_to do |f|
      f.html {
        @employees = Employee.joins(:contact).page(params[:page])
        render :index
      }
      f.json { render json: Employee.all }
    end

  end

  def search_by_name
    where_name = "%#{params[:search_name]}%"
    @employees = Employee.joins(:contact)
      .where(
        'contacts.lname like ? or contacts.fname like ? or employees.user_name like ?',
        where_name,
        where_name,
        where_name)

    respond_to do |f|
      f.html {
        @employees = @employees.page params[:page]
        render :index
      }
      f.json { render json: @employees }
    end

  end

  def new
    @employee = Employee.new
    if (params.has_key?(:contact_id))
      @contact = Contact.find(params[:contact_id])
      @employee.contact = @contact
    end

    respond_to do |f|
      f.html
    end

  end

  def edit
    @employee = Employee.joins(:contact).find(params[:id])
    @contact = @employee.contact
  end

  def update
    @employee = Employee.find(params[:id])
    respond_to do |f|
      if @employee.update(update_params)
        f.html { redirect_to @employee, notice: "Record updated." }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_entity }
        f.json { json_failure @employee.errors }
      end

    end

  end

  def create
    @employee =  Employee.new(new_params)
    if (params.has_key? :contact_id)
      @contact = Contact.find(params[:contact_id])
      @ou = Ou.find(params[:ou_id])
      @employee.ou = @ou
      @employee.contact = @contact
    end

    respond_to do |f|
      if  @employee.save
        f.html { redirect_to @employee, notice: "Employee created." }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_entity }
        f.json { json_failure @employee.errors }
      end
    end
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def destroy
    @employee = Employee.find(params[:id])
    @employee.destroy
    respond_to do |f|
      f.html { redirect_to employees_url, notice: "Deletion successfull" }
      f.json { json_success }
    end

  end

  private
  def new_params
    params.require(:employee).permit(:id, :contact_id, :ou_id, :date_hired,:user_name,  :position, :password, :password_confirmation)
  end

  def update_params
    params.require(:employee).permit(:ou_id, :date_hired, :position, :password, :user_name, :password_confirmation, :user_name)
  end
end
