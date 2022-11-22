class ClientEmailsController < ApplicationController
  before_action(only: [:show, :index]) { process_permission has_read_permission(:client_attribute) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:client_attribute) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:client_attribute) }
  before_action(only: [:destroy]) { process_permission has_delete_permission(:client_attribute) }
  def new
    populate_new
  end

  def create
    populate_new new_params

    respond_to do |f|
      if @client_email.save
        f.html { redirect_to clients_show2_path(@client), notice: "#{ClientEmail.model_name.human} #{@client_email.email} added." }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_entity }
        f.json { json_failue @client_email.errors }
      end
    end
  end

  def edit
    populate_edit
  end

  def update
    populate_edit

    respond_to do |f|
      if @client_email.update(update_params)
        f.html { redirect_to clients_show2_path(@client), notice: "#{ClientEmail.model_name.human} updated." }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_entity }
        f.json { json_failure @client_email.erros }
      end
    end
  end

  def destroy
    populate_edit

    @client_email.delete

    respond_to do |f|
      f.html { redirect_to clients_show2_path(@client), notice: "#{ClientEmail.model_name.human} deleted." }
      f.json { json_success }
    end
  end
  private
  def new_params
    params.require(:client_email).permit(:id, :email, :description, :client_id)
  end

  def update_params
    params.require(:client_email).permit(:id,:email, :description)
  end

  def populate_new fill = nil
    if fill
      @client_email = ClientEmail.new(fill)
    else
      @client_email = ClientEmail.new
    end
    @client = Client.find params[:client_id]
    @client_email.client = @client
  end

  def populate_edit
    @client_email = ClientEmail.find params[:id]
    @client = Client.find params[:client_id]
    @client_email.client = @client
  end
end
