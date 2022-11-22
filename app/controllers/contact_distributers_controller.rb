class ContactDistributersController < ApplicationController
	before_action(only: [:show, :index]) { process_permission has_read_permission(:distributer_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:distributer_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:distributer_attribute) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:distributer_attribute) }

	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @contact_distributer.save
				f.html { redirect_to @distributer, notice: "#{@contact_distributer.contact.full_name} added." }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @contact_distributer.errors }
			end

		end

	end

	def edit
		populate_edit
	end

	def update
		populate_edit

		respond_to do |f|
			if @contact_distributer.update new_params
				f.html { redirect_to @distributer, notice: "#{ContactDistributer.model_name.human} updated." }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @contact_distributer.errors }
			end

		end

	end

	def destroy
		populate_edit

		respond_to do |f|
			if @contact_distributer.delete
				f.html { redirect_to @distributer, notice: "#{ContactDistributer.model_name.human} deleted." }
				f.json { json_success }
			else
				f.html { redirect_to @distributer, alert: "Error deleting #{ContactDistributer.model_name.human}" }
				f.json { json_failure }
			end

		end

	end

	private

	def new_params
		params.require(:contact_distributer).permit(:id, :contact_id, :distributer_id, :description)
	end

	def populate_new fill = nil
		if (fill)
			@contact_distributer = ContactDistributer.new fill
		else
			@contact_distributer = ContactDistributer.new
		end

		@distributer = Distributer.find params[:distributer_id]
		@contact_distributer.distributer = @distributer
	end

	def populate_edit
		@contact_distributer = ContactDistributer.find params[:id]
		@distributer = Distributer.find params[:distributer_id]
		@contact_distributer.distributer = @distributer
	end
end
