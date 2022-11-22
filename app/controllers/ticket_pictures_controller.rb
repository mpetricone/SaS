class TicketPicturesController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action(only: [:show, :index]) { process_permission has_read_permission(:ticket_attribute) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:ticket_attribute) }
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
      if @ticket_picture.save
        f.html { redirect_to @ticket, notice: t(:notice_image_attached) }
      else
        f.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    populate_edit

    respond_to do |f|
      if @ticket_picture.update new_params
        f.html { redirect_to @ticket, notice: t(:notice_image_updated) }
      else
        f.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    populate_edit

    respond_to do |f|
      @ticket_picture.image.purge
      if @ticket_picture.destroy
        f.html { redirect_to @ticket, notice: t(:notice_image_deleted) }
      else
        f.html { redirect_to @ticket, alert: t(:alert_image_not_deleted) }
      end
    end
  end

  private

  def new_params
    params.require(:ticket_picture).permit(:id, :ticket_id, :taken_at, :note, :description, :image)
  end

  def populate_new(fill = nil)
    @ticket_picture = TicketPicture.new fill
    @ticket = Ticket.find params[:ticket_id]
    @ticket_picture.ticket = @ticket
  end

  def populate_edit
    @ticket_picture = TicketPicture.find params[:id]
    @ticket = Ticket.find params[:ticket_id]
    @ticket_picture.ticket = @ticket
  end
end
