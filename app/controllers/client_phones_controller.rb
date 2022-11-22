class ClientPhonesController < ApplicationController
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
			if @client_phone.save
				f.html { redirect_to clients_show2_path(@client), notice: "Updated #{@client.name}." }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @client.errors}
			end

		end

	end

	def edit
		populate_update
	end

	def update
		populate_update

		respond_to do |f|
			if @client_phone.update(update_params)
				f.html { redirect_to clients_show2_path(@client), notice: "Updated #{@client.name}." }
				f.json { json_success }
			else
				f.html {render :edit, status: :unprocessable_entity  }
				f.json { json_failure @client.errors }
			end

		end

	end

	def destroy
		populate_update
		@client_phone.destroy
		respond_to do |f|
			f.html { redirect_to clients_show2_path(@client), notice: "#{ClientPhone.model_name.human} deleted." }
			f.json { json_success }
		end

	end

	private
	def new_params
		params.require(:client_phone).permit(:id, :number, :description, :client_id)
	end

	def update_params
		params.require(:client_phone).permit(:number, :description)
	end

	def populate_new fill = nil
		if fill
			@client_phone = ClientPhone.new fill
		else
			@client_phone = ClientPhone.new
		end

		@client = Client.find params[:client_id]
		@client_phone.client = @client
	end

	def populate_update
		@client_phone = ClientPhone.find params[:id]
		@client = Client.find params[:client_id]
		@client_phone.client = @client
	end
end
