class ClientContactsController < ApplicationController
	before_action(only: [:show, :index]) { process_permission has_read_permission(:client_attribute) }
	before_action(only: [:edit, :update]) {process_permission has_write_permission(:client_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:client_attribute) }
	before_action(only: [:destroy]) {process_permission has_delete_permission(:client_attribute) }
	def edit
		@client_contact = ClientContact.find params[:id]
		@client = Client.find params[:client_id]
	end

	def update
		@client_contact = ClientContact.find(params[:id])
		@client = Client.find(params[:client_id])

		respond_to do |format|
			if @client_contact.update(update_params)
				format.html { redirect_to clients_show2_path(@client), notice: "#{@client.name} updated." }
			else
				format.html { render :edit, status: :unprocessable_entity }
			end

		end

	end

	def new
		@client_contact = ClientContact.new
		@client = Client.find params[:client_id]
		@client_contact.client = @client
	end

	def create
		@client_contact = ClientContact.new(new_params)
		@client = Client.find params[:client_id]
		@client_contact.client = @client
		respond_to do |f|
			if @client_contact.save
				f.html { redirect_to clients_show2_path(@client), notice: "#{@client.name} updated."  }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @client_contact.errors }
			end

		end

	end

	def destroy
		@client_contact = ClientContact.find params[:id]
		@client = Client.find params[:client_id]

		@client_contact.delete
		respond_to do |f|
			f.html { redirect_to clients_show2_path(@client), notice: "#{ClientContact.model_name.human} deleted." }
			f.json { json_success }
		end

	end

	private
	def new_params
		params.require(:client_contact).permit(:id, :client_id, :contact_id)
	end

	def update_params
		params.require(:client_contact).permit(:contact_id)
	end
end
