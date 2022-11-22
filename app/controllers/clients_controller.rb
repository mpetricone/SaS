class ClientsController < ApplicationController
  before_action(only: [:show, :index, :search_by_name, :search_statement]) { process_permission has_read_permission(:contact) }
  before_action(only: [:edit, :update]) { process_permission has_write_permission(:client) }
  before_action(only: [:new, :create]) { process_permission has_create_permission(:client) }
  before_action(only: [:destroy ]) { process_permission has_delete_permission(:client) }

  def new
    @client = Client.new
    @client.client_phones.build
    @client.client_emails.build
    @client.address_clients.build(address: Address.new)
    @client.client_contacts.build
    @client.client_rates.build
  end

  def index
    @clients = Client.page(params[:page])
    respond_to do |f|
      f.html { render :index }
      f.json { render json: @clients  }
    end
  end

  def search_by_name
    # leaving this singular for index view
    @clients = Client.where("name like ?",  "%#{params[:search_name]}%");
    respond_to do |f|
      f.html {
        @clients = @clients.page(params[:page])
        render :index }
      f.json { render json: @clients }
    end
  end

  def show
    @client = Client.find params[:id]
    @tickets = @client.tickets.order("updated_at DESC").where.not(ticket_status: TicketStatus.where(name: [TicketStatus::CLOSED, TicketStatus::SOLVED])).limit(5)
    @ac = @client.accounts_receivable(Date.today-365, Date.today)
    respond_to do |f|
      f.html { render :show2 }
    end
  end

  def show2
    @client = Client.find params[:id]
    respond_to do |f|
      f.html { render :show }
      f.json {
        render json: {
          client: @client,
          client_contacts: @client.client_contacts,
          contacts: @client.contacts,
          client_emails: @client.client_emails,
          client_phones: @client.client_phones,
          address_clients: @client.address_clients,
          addresses: @client.addresses,
          client_rates: @client.client_rates,
          rates: @client.rates,
          standing: @client.standing,
          default_invoice_address: @client.default_invoice_address,
          default_delivery_address: @client.default_delivery_address
        }
      }
    end
  end

  def edit
    @client =  Client.find params[:id]
  end

  def update
    @client = Client.find params[:id]

    respond_to do |f|
      if @client.update(new_params)
        # ensure there are defaults
        @client.enforce_address_compatibility
        f.html { redirect_to @client, notice: "Updated record." }
        f.json { json_success }
      else
        f.html { render :edit, status: :unprocessable_entity}
        f.html { json_failure @client.errors }
      end
    end
  end

  def create
    @client = Client.new(new_params)
=begin
#this has been moved to repond
    if (!@client.address_clients.empty?)
      @client.default_invoice_address = @client.address_clients.first.address
      @client.default_delivery_address = @client.address_clients.first.address
      @client.address_clients.each do |t|
        flash[t.id] = t.address.id
      end
    else
      flash[:error] = "There was an internal error."
    end

=end

    respond_to do |f|
      if (@client.save)
        #makes sure there are default delivery/invoce addresses
        @client.enforce_address_compatibility
        f.html { redirect_to clients_path, notice: "Created record" }
        f.json { json_success }
      else
        f.html { render :new, status: :unprocessable_entity }
        f.json { json_failure @client.errors }
      end
    end
  end

  def destroy
    @client = Client.find params[:id]
    @client.destroy
    respond_to do |f|
      f.html { redirect_to clients_path, notice: "Record destroyed" }
      f.json { json_success }
    end
  end

  private
  def new_params
    params.require(:client).permit(
      :id, :name, :standing_id, :default_invoice_id,
      :default_delivery_id, :refuse,
      :tax_exemption, client_contacts_attributes: [
        :id, :client_id, :contact_id
      ], address_clients_attributes: [
        :id, :address_id, :client_id, :invoice,
        :delivery, address_attributes: [
          :id,  :street1, :street2, :city, :state, :postal_code, :country, :status
        ]
      ], client_phones_attributes: [
        :id,:client_id, :number, :description
      ], client_emails_attributes: [
        :id, :client_id, :email, :description
      ], client_rates_attributes: [
        :id, :current, :date_implemented, :date_retired,  :rate_id, :client_id
      ]
    )
  end

  def update_params
    params.require(:client).permit(
      :name, :description, :standing_id, :default_invoice_id,
      :default_delivery_id, :refuse,
      :tax_exemption, client_contacts_attributes: [
        :id, :client_id, :contact_id
      ], address_clients_attributes: [
        :id, :client_id, :address_id,
        :invoice, :delivery, address_attributes: [
          :id,:street1, :street2, :city, :state, :postal_code, :country, :status
        ]
      ], client_phones_attributes: [
        :id,:client_id, :number, :description
      ], client_emails_attributes: [
        :id,:client_id, :email, :description
      ], client_rates_attributes: [
        :id, :current, :date_implemented,:date_retired, :rate_id, :client_id
      ]
    )
  end
end
