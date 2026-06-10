class DistributerEmailsController < ApplicationController
  before_action { authorize DistributerEmail }
	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @distributer_email.save
				f.html { redirect_to @distributer, notice: t(:notice_added, item: DistributerEmail.model_name.human) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
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
				f.html { redirect_to @distributer, notice: t(:notice_updated, item: DistributerEmail.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @distributer_email }
			end

		end

	end

	def destroy
		populate_edit

		respond_to do |f|
			if @distributer_email.destroy
				f.html { redirect_to @distributer, notice: t(:notice_removed, item: DistributerEmail.model_name.human) }
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
