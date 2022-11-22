class DistributerEmailsController < ApplicationController
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
			if @distributer_email.save
				f.html { redirect_to @distributer, notice: "#{DistributerEmail.model_name.human} #{@distributer_email.email} added." }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @distributer_email }
			end

		end

	end

	def edit
		populate_edit
	end

	def update
		populate_edit

		respond_to do |f|
			if @distributer_email.update new_params
				f.html { redirect_to @distributer, notice: "#{DistributerEmail.model_name.human} #{@distributer_email.email} updated." }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @distributer_email }
			end

		end

	end

	def destroy
		populate_edit

		respond_to do |f|
			if @distributer_email.destroy
				f.html { redirect_to @distributer, notice: "#{DistributerEmail.model_name.human} deleted" }
				f.json { json_success }
			else
				f.html { redirect_to @distributer, alrt: "Error deleting #{Distributer.model_name.human}." }
				f.json { json_failure @distributer_email }
			end

		end

	end

	private

	def new_params
		params.require(:distributer_email).permit(:id, :distributer_id, :email, :description)
	end

	def populate_new fill = nil
		if fill
			@distributer_email = DistributerEmail.new new_params
		else
			@distributer_email = DistributerEmail.new
		end

		@distributer = Distributer.find params[:distributer_id]
		@distributer_email.distributer = @distributer
	end

	def populate_edit
		@distributer_email = DistributerEmail.find params[:id]
		@distributer = Distributer.find params[:distributer_id]
		@distributer_email.distributer = @distributer
	end
end
