class ContactEmailsController < ApplicationController
	before_action(only: [:show, :index]) { process_permission has_read_permission(:distributer_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:distributer_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:distributer_attribute) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:distributer_attribute) }

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
				format.html { redirect_to @contact_email.contact, notice: 'Contact email was successfully created.' }
				format.json { json_success}
			else
				format.html { render :new, status: :unprocessable_entity }
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
				format.html { redirect_to @contact, notice: 'Contact email was successfully updated.' }
				format.json { json_success }
			else
        format.html { render :edit, status: :unprocessable_entity }
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
			format.html { redirect_to @contact, notice: 'Contact email was successfully removed.' }
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
