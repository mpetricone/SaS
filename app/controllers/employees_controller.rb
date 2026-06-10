class EmployeesController < ApplicationController
  before_action { authorize Employee }

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
        f.html { redirect_to @employee, notice: t(:notice_record_updated) }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_content }
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
        f.html { redirect_to @employee, notice: t(:notice_added, item: Employee.model_name.human) }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_content }
        f.json { json_failure @employee.errors }
      end
    end
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def unlock
    @employee = Employee.find(params[:id])
    @employee.unlock!
    Audit.event(:account_unlocked,
                employee: @employee,
                request:  request,
                details:  { by_employee_id: current_employee.id })
    redirect_to edit_employee_path(@employee), notice: t(:notice_unlocked, name: @employee.contact.full_name)
  end

  ##def destroy
  ##  @employee = Employee.find(params[:id])
  ##  @employee.destroy
  ##  respond_to do |f|
  ##    f.html { redirect_to employees_url, notice: "Deletion successfull" }
  ##    f.json { json_success }
  ##  end
  ##end

  private
  def new_params
    params.require(:employee).permit(:id, :contact_id, :ou_id, :date_hired,:user_name,  :position, :password, :password_confirmation)
  end

  def update_params
    params.require(:employee).permit(:ou_id, :date_hired, :position, :password, :user_name, :password_confirmation, :user_name)
  end
end
