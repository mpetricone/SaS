class TicketWorkTypesController < ApplicationController
  before_action { authorize TicketWorkType }

  def new
    populate_new
  end

  def create
    populate_new new_params
    respond_to do |f|
      if @ticket_work_type.save
        f.html { redirect_to @ticket, notice: t(:notice_added, item: TicketWorkType.model_name.human) }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_content }
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
        f.html { redirect_to @ticket, notice: t(:notice_updated, item: TicketWorkType.model_name.human) }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_content }
        f.json { json_failure @ticket_work_type.errors }
      end
    end
  end

  def destroy
    populate_edit
    respond_to do |f|
      if @ticket_work_type.delete
        f.html { redirect_to @ticket, notice: t(:notice_removed, item: TicketWorkType.model_name.human) }
        f.json { json_success }
      else
        f.html { redirect_to @ticket, alert: t(:alert_not_removed, item: TicketWorkType.model_name.human) }
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
