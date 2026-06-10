class ClientContactsController < ApplicationController
  before_action { authorize ClientContact }
	def edit
		@client_contact = ClientContact.find params[:id]
		@client = Client.find params[:client_id]
	end

	def update
		@client_contact = ClientContact.find(params[:id])
		@client = Client.find(params[:client_id])

		respond_to do |format|
			if @client_contact.update(update_params)
				format.html { redirect_to clients_show2_path(@client), notice: t(:notice_updated, item: @client.name) }
			else
				format.html { render :edit, status: :unprocessable_content }
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
				f.html { redirect_to clients_show2_path(@client), notice: t(:notice_updated, item: @client.name)  }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @client_contact.errors }
			end

		end

	end

	def destroy
		@client_contact = ClientContact.find params[:id]
		@client = Client.find params[:client_id]

		@client_contact.delete
		respond_to do |f|
			f.html { redirect_to clients_show2_path(@client), notice: t(:notice_removed, item: ClientContact.model_name.human) }
			f.json { json_success }
		end

	end

	private
	def new_params
		params.require(:client_contact).permit(:id, :client_id, :contact_id, :receives_quotes)
	end

	def update_params
		params.require(:client_contact).permit(:contact_id, :receives_quotes)
	end
end
