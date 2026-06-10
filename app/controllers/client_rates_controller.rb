class ClientRatesController < ApplicationController
  before_action { authorize ClientRate }

	def new
		populate_new
		@client_rate.date_implemented = Time.now
		@client_rate.current = true
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @client_rate.save
				f.html { redirect_to clients_show2_path(@client), notice: t(:notice_added, item: ClientRate.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @client_rate.errors }
			end

		end

	end

	def edit
		populate_edit
	end

	def update
		populate_edit

		respond_to do |f|
			if @client_rate.update new_params
				f.html { redirect_to clients_show2_path(@client), notice: t(:notice_updated, item: ClientRate.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_fauilure @client_rate.errors }
			end

		end

	end

	def destroy
		populate_edit
		@client_rate.delete
		respond_to do |f|
			f.html { redirect_to clients_show2_path(@client), notice: t(:notice_removed, item: ClientRate.model_name.human) }
			f.json { json_success }
		end

	end

	private
	def new_params
		params.require(:client_rate).permit(:id, :client_id, :rate_id, :date_implemented, :date_retired, :current)
	end

	def populate_new fill = nil
		if fill
			@client_rate = ClientRate.new fill
		else
			@client_rate = ClientRate.new
		end

		@client = Client.find params[:client_id]
		@client_rate.client = @client
	end

	def populate_edit
		@client_rate = ClientRate.find params[:id]
		@client = Client.find params[:client_id]
		@client_rate.client = @client
	end
end
