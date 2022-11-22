class TicketWorkTypesController < ApplicationController
  before_action(only: [:show, :index]) { process_permission has_read_permission(:ticket_attribute) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:ticket_attribute) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:ticket_attribute) }
  before_action(only: [:desroy]) { process_permission has_delete_permisison(:ticket_attribute) }

  def new
    populate_new
  end

  def create
    populate_new new_params
    respond_to do |f|
      if @ticket_work_type.save
        f.html { redirect_to @ticket, notice: "#{TicketWorkType.model_name.human} added." }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_entity }
        f.json { json_failure @ticket_work_type.errors }
      end
    end
  end

  def edit
    populate_edit
  end

  def update
    populate_edit
    respond_to do |f|
      if @ticket_work_type.update new_params
        f.html { redirect_to @ticket, notice: "#{TicketWorkType.model_name.human} altered." }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_entity }
        f.json { json_failure @ticket_work_type.errors }
      end
    end
  end

  def destroy
    populate_edit
    respond_to do |f|
      if @ticket_work_type.delete
        f.html { redirect_to @ticket, notice: "#{TicketWorkType.model_name.human} removed." }
        f.json { json_success }
      else
        f.html { redirect_to @ticket, alert: "Error removing #{TikcketWorkType.model_name.human}" }
        f.json { json_failure @ticket_work_type.errors }
      end
    end
  end

  private

  def new_params
    params.require(:ticket_work_type).permit(:id, :ticket_id, :work_type_id)
  end

  def populate_new fill = nil
    if fill
      @ticket_work_type = TicketWorkType.new fill
    else
      @ticket_work_type = TicketWorkType.new
    end
    @ticket = Ticket.find params[:ticket_id]
    @ticket_work_type.ticket = @ticket
  end

  def populate_edit
    @ticket_work_type = TicketWorkType.find params[:id]
    @ticket = Ticket.find params[:ticket_id]
    @ticket_work_type.ticket = @ticket
  end
end
