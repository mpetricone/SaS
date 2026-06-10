class ClientNotesController < ApplicationController
  before_action { authorize ClientNote }
	def new
		populate_new
	end

	def index
		respond_to do |f|
			@client_notes = ClientNote.where(client_id: params[:client_id])
			f.json { render json:  @client_notes  }
		end

	end

	def create
		populate_new new_params

		respond_to do |f|
			if @client_note.save
				f.html { redirect_to clients_show2_path(@client), notice: t(:notice_added, item: ClientNote.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure @client_note.errors }
			end

		end

	end

	def edit
		populate_edit
	end

	def update
		populate_edit

		respond_to do |f|
			if @client_note.update new_params
				f.html { redirect_to clients_show2_path(@client), notice: t(:notice_updated, item: ClientNote.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @client_note.errors }
			end

		end

	end

	def destroy
		populate_edit

		@client_note.destroy

		respond_to do |f|
			f.html { redirect_to clients_show2_path(@client), notice: t(:notice_removed, item: ClientNote.model_name.human) }
			f.json { json_success }
		end

	end

	private
	def new_params
		params.require(:client_note).permit(:id, :note, :title, :client_id)
	end

	def update_params
		params.require(:client_note).permit(:note, :title)
	end

	def populate_new fill = nil
		if (fill)
			@client_note = ClientNote.new(fill)
		else
			@client_note = ClientNote.new
		end

		@client = Client.find params[:client_id]
		@client_note.client = @client
	end

	def populate_edit
		@client_note = ClientNote.find params[:id]
		@client = Client.find params[:client_id]
		@client_note.client = @client
	end
end
