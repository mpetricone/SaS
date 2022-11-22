class TicketNotesController < ApplicationController
  before_action(only: [:show, :index]) { process_permission has_read_permission(:ticket_attribute) }
  before_action(only: [:update]) { process_permission has_write_permission(:ticket_attribute) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:ticket_attribute) }
  before_action(only: [:destroy]) { process_permission has_delete_permission(:ticket_attribute) }

  def new
    populate_new
  end

  def edit
    populate_edit
  end

  def show
    populate_edit
  end

  def create
    populate_new new_params

    respond_to do |f|
      if @ticket_note.save
        f.html { redirect_to @ticket, notice: t(:notice_added, item: TicketNote.model_name.human) }
      else
        f.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    populate_edit

    respond_to do |f|
      if @ticket_note.update new_params
        f.html { redirect_to @ticket, notice: t(:notice_updated, item: TicketNote.model_name.human) }
      else
        f.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    populate_edit

    respond_to do |f|
      if @ticket_note.destroy
        f.html { redirect_to @ticket, notice: t(:notice_removed, item: TicketNote.model_name.human) }
      else
        f.html { redirct_to @ticket, alert: t(:alert_not_removed, item: TicketNote.model_name.human) }
      end
    end
  end

  private

  def populate_edit
    @ticket_note = TicketNote.find params[:id]
    @ticket = Ticket.find params[:ticket_id]
  end

  def populate_new(fill = nil)
    @ticket_note = TicketNote.new fill
    @ticket = Ticket.find params[:ticket_id]
    @ticket_note.ticket = @ticket
  end

  def new_params
    params.require(:ticket_note).permit(:id, :ticket_id, :subject, :body)
  end
end
