class TicketActionsController < ApplicationController
  before_action(only: [:show, :index]) { process_permission has_read_permission(:ticket_attribute) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:ticket_attribute) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:ticket_attribute) }
  before_action(only: [:destroy]) { process_permission has_delete_permission(:ticket_attribute) }

  def new
    populate_new
		@ticket_action.date_taken = Time.now
  end

  def create
    populate_new new_params
    @ticket_action.employee = get_current_employee
    respond_to do |f|
      if (@ticket_action.save)
        f.html { redirect_to @ticket, notice: "Added #{TicketAction.model_name.human}." }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_entity }
        f.json { json_failure @ticket_action.errors }
      end
    end
  end

  def edit
    populate_edit
  end

  def update
    populate_edit
    respond_to do |f|
      if (@ticket_action.update new_params)
        f.html { redirect_to @ticket, notice: "Altered #{TicketAction.model_name.human}." }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_entity }
        f.json { json_failure @ticket_action.errors }
      end
    end
  end

  def destroy
    populate_edit
    respond_to do |f|
      if @ticket_action.destroy
        f.html { redirect_to @ticket, notice: "Removed #{TicketAction.model_name.human}." }
        f.json { json_success }
      else
        f.html { redirect_to @ticket, alert: "Error removing #{TickertAction.model_name.human}." }
        f.json { json_failure @ticket_action.errors }
      end
    end
  end

  private
  def new_params
    params.require(:ticket_action).permit(:id, :ticket_id, :action_status_id, :employee_id, :date_taken, :action)
  end

  def populate_new fill=nil
    if fill
      @ticket_action = TicketAction.new fill
    else
      @ticket_action = TicketAction.new
    end
    @ticket = Ticket.find params[:ticket_id]
    @ticket_action.ticket = @ticket
  end

  def populate_edit
    @ticket_action = TicketAction.find params[:id]
    @ticket = Ticket.find params[:ticket_id]
    @ticket_action.ticket = @ticket;
  end

end
