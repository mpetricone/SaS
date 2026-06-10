class OuEmailsController < ApplicationController
  before_action { authorize OuEmail }

	def new
		@ou = Ou.find params[:ou_id]
		@ouEmail = OuEmail.new
		@ouEmail.ou = @ou
	end

	def create
		@ou = Ou.find(params[:ou_id])
		@ouEmail = OuEmail.new(new_ou_email_params)
		@ouEmail.ou = @ou;

		respond_to do |f|
			if @ouEmail.save
				f.html {
					flash[:notice] = t(:notice_added, item: OuEmail.model_name.human)
					redirect_to @ou
				}
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_content }
				f.json { json_failure }
			end

		end

	end

	def edit
		@ou = Ou.find(params[:ou_id])
		@ouEmail = OuEmail.find(params[:id])
	end

	def update
		@ou = Ou.find(params[:ou_id])
		@ouEmail = OuEmail.find(params[:id])
		respond_to do |f|
			if @ouEmail.update(new_ou_email_params)
				f.html { redirect_to @ou }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_content }
				f.json { json_failure @ouEmail.errors }
			end

		end

	end

	def destroy
		@ouEmail = OuEmail.find params[:id]
		@ou = Ou.find params[:ou_id]
		respond_to do |f|
			if @ouEmail.destroy
				f.html { redirect_to @ou, notice: t(:notice_removed, item: OuEmail.model_name.human) }
				f.json { json_success }
			else
				f.html { redirect_to @ou, alert: t(:alert_not_removed, item: OuEmail.model_name.human) }
				f.json { json_failure @ouEmail.errors }
			end

		end

	end

	private
	def new_ou_email_params
		params.require(:ou_email).permit(:id, :ou_id, :address, :description)
	end
end
