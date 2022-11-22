# wtf vscode
class AddressClientsController < ApplicationController
  before_action(only: [:show, :index]) { process_permission has_read_permission(:client_attribute) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:client_attribute) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:client_attribute) }
  before_action(only: [:destroy]) { process_permission has_delete_permission(:client_attribute) }

  def new
    @address_client = AddressClient.new
    @address_client.address = Address.new
    @client = Client.find params[:client_id]
    @address_client.client = @client
  end

  def create
    @address_client = AddressClient.new(new_params)
    @client = Client.find params[:client_id]
    @address_client.client = @client
    respond_to do |f|
      if @address_client.save
        f.html { redirect_to clients_show2_path(@client), notice: "#{@client.name} updated" }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_entity }
        f.json { json_failure @address_client.errors }
      end

    end

  end

  def edit
    populate_update
  end

  def update
    populate_update

    respond_to do |f|
      if @address_client.update(update_params)
        f.html { redirect_to clients_show2_path(@client), notice: "#{@client.name} updated." }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_entity }
        f.json { json_failure @address_client.errors }
      end

    end

  end

  def destroy
    populate_update
    @address_client.delete
    respond_to do |f|
      f.html { redirect_to clients_show2_path(@client), notice: "#{AddressClient.model_name.human} record deleted."}
      f.json { json_success }
    end

  end

  private
  def new_params
    params.require(:address_client).permit(:id, :client_id, :address_id, :delivery, :invoice,
                                           address_attributes: [:id, :street1, :street2, :city, :postal_code, :state, :country ,:status])
  end

  def update_params
    params.require(:address_client).permit(:id, :client_id,:address_id, :delivery, :invoice,
                                           address_attributes: [:id, :street1, :street2, :city, :postal_code, :state, :country, :status])
  end

  def populate_update
    @address_client= AddressClient.find(params[:id])
    @client = Client.find params[:client_id]
    @address_client.client = @client
  end
end
