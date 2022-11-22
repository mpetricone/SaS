class OuEmailsController < ApplicationController
	before_action(only: [:show, :index]) { process_permission has_read_permission(:ou_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:ou_attriute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:ou_attribute) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:ou_attribute) }

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
					flash[:success] = "E-mail record created"
					redirect_to @ou
				}
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
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
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @ouEmail.errors }
			end

		end

	end

	def destroy
		@ouEmail = OuEmail.find params[:id]
		@ou = Ou.find params[:ou_id]
		respond_to do |f|
			if @ouEmail.destroy
				f.html { redirect_to @ou, notice: "#{OuEmail.model_name.human} removed." }
				f.json { json_success }
			else
				f.html { redirect_to @ou, alert: "Error removing #{OuEmail.model_name.human}" }
				f.json { json_failure @ouEmail.errors }
			end

		end

	end

	private
	def new_ou_email_params
		params.require(:ou_email).permit(:id, :ou_id, :address, :description)
	end
end
