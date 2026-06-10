class ContactEmailsController < ApplicationController
  before_action { authorize ContactEmail }

	before_action :set_contact_email, only: [:show, :edit, :update, :destroy]

	# GET /contact_emails
	# GET /contact_emails.json
	def index
		@contact_emails = ContactEmail.all
		@contact = Contact.find params[:contact_id]
	end

	# GET /contact_emails/1
	# GET /contact_emails/1.json
	def show
		@contact = Contact.find params[:contact_id]
	end

	# GET /contact_emails/new
	def new
		@contact_email = ContactEmail.new
		@contact = Contact.find params[:contact_id]
		@contact_email.contact = @contact
	end

	# GET /contact_emails/1/edit
	def edit
		@contact = Contact.find params[:contact_id]
	end

	# POST /contact_emails
	# POST /contact_emails.json
	def create
		@contact_email = ContactEmail.new(new_contact_email_params)
		@contact = Contact.find params[:contact_id]
		@contact_email.contact = @contact;

		respond_to do |format|
			if @contact_email.save
				format.html { redirect_to @contact_email.contact, notice: t(:notice_added, item: ContactEmail.model_name.human) }
				format.json { json_success}
			else
				format.html { render :new, status: :unprocessable_content }
				format.json { json_failure }
			end

		end

	end

	# PATCH/PUT /contact_emails/1
	# PATCH/PUT /contact_emails/1.json
	def update
		@contact = Contact.find params[:contact_id]
		@contact_email.contact = @contact
		respond_to do |format|
			if @contact_email.update(contact_email_params)
				format.html { redirect_to @contact, notice: t(:notice_updated, item: ContactEmail.model_name.human) }
				format.json { json_success }
			else
        format.html { render :edit, status: :unprocessable_content }
				format.json { json_failure }
			end

		end

	end

	# DELETE /contact_emails/1
	# DELETE /contact_emails/1.json
	def destroy
		@contact = Contact.find params[:contact_id]
		@contact_email.destroy
		respond_to do |format|
			format.html { redirect_to @contact, notice: t(:notice_removed, item: ContactEmail.model_name.human) }
			format.json { json_success }
		end

	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_contact_email
		@contact_email = ContactEmail.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def contact_email_params
		params.require(:contact_email).permit(:address)
	end

	def new_contact_email_params
		params.require(:contact_email).permit(:id, :address, :contact_id)
	end
end
