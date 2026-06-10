class DistributerPhonesController < ApplicationController
  before_action { authorize DistributerPhone }

	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @distributer_phone.save
				f.html { redirect_to @distributer, notice: t(:notice_added, item: DistributerPhone.model_name.human)  }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
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
				f.html { redirect_to @distributer, notice: t(:notice_updated, item: DistributerPhone.model_name.human) }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @distributer_phone }
			end

		end

	end

	def destroy
		populate_edit

		respond_to do |f|
			if @distributer_phone.destroy
				f.html { redirect_to @distributer, notice: t(:notice_removed, item: DistributerPhone.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to @distributer, alert: t(:alert_not_removed, item: DistributerPhone.model_name.human) }
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
