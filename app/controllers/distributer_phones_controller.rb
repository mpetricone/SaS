class DistributerPhonesController < ApplicationController
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
			if @distributer_phone.save
				f.html { redirect_to @distributer, notice: "#{DistributerPhone.model_name.human} #{@distributer_phone.number} added."  }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @distributer_phone }
			end

		end

	end

	def edit
		populate_edit
	end

	def update
		populate_edit

		respond_to do |f|
			if @distributer_phone.update new_params
				f.html { redirect_to @distributer, notice: "#{DistributerPhone.model_name.human} updated." }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @distributer_phone }
			end

		end

	end

	def destroy
		populate_edit

		respond_to do |f|
			if @distributer_phone.destroy
				f.html { redirect_to @distributer, notice: "#{DistributerPhone.model_name.human} removed." }
				f.json { json_success }
			else
				f.html { redirect_to @distributer, alert: "Error removing #{DistributerPhone.model_name.human}." }
				f.json { json_failure @distributer_phone }
			end

		end

	end

	private
	def new_params
		params.require(:distributer_phone).permit( :id, :distributer_id, :number, :description)
	end

	def populate_new fill = nil
		if (fill)
			@distributer_phone = DistributerPhone.new fill
		else
			@distributer_phone = DistributerPhone.new
		end

		@distributer = Distributer.find params[:distributer_id]
		@distributer_phone.distributer = @distributer
	end

	def populate_edit
		@distributer_phone = DistributerPhone.find params[:id]
		@distributer = Distributer.find params[:distributer_id]
		@distributer_phone.distributer = @distributer
	end
end
