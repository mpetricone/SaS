class ClientEmailsController < ApplicationController
  before_action { authorize ClientEmail }
  def new
    populate_new
  end

  def create
    populate_new new_params

    respond_to do |f|
      if @client_email.save
        f.html { redirect_to clients_show2_path(@client), notice: t(:notice_added, item: ClientEmail.model_name.human) }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_content }
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
        f.html { redirect_to clients_show2_path(@client), notice: t(:notice_updated, item: ClientEmail.model_name.human) }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_content }
        f.json { json_failure @client_email.erros }
      end
    end
  end

  def destroy
    populate_edit

    @client_email.delete

    respond_to do |f|
      f.html { redirect_to clients_show2_path(@client), notice: t(:notice_removed, item: ClientEmail.model_name.human) }
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
