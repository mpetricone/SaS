class ContactDistributersController < ApplicationController
  before_action { authorize ContactDistributer }

	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @contact_distributer.save
				f.html { redirect_to @distributer, notice: t(:notice_added, item: @contact_distributer.contact.full_name) }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
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
				f.html { redirect_to @distributer, notice: t(:notice_updated, item: ContactDistributer.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @contact_distributer.errors }
			end

		end

	end

	def destroy
		populate_edit

		respond_to do |f|
			if @contact_distributer.delete
				f.html { redirect_to @distributer, notice: t(:notice_removed, item: ContactDistributer.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to @distributer, alert: t(:alert_not_removed, item: ContactDistributer.model_name.human) }
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
