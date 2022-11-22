class ContactsController < ApplicationController
	before_action :set_contact, only: [:show, :edit, :update, :destroy]
	before_action(only: [:show, :index, :search_by_name]) { process_permission has_read_permission(:contact) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:contact) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:contact) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:contact) }

	# GET /contacts
	# GET /contacts.json
	def index
		respond_to do |f|
			f.html {
				@contacts = Contact.page(params[:page]);
				render :index
			}
			f.json {
				@contacts = Contact.all
				render json: @contacts
			}
		end

	end

	def search_by_name
		if (params.has_key?('search_name') )
			@contacts = Contact.where('fname like ? OR lname like ?', "%#{params[:search_name]}%", "%#{params[:search_name]}%")
		elsif
			@contacts = Contact.where('fname like ? AND lname like ?', "%#{params[:search_fname]}%", "%#{params[:search_lname]}%")
		end

		if (params.has_key?('exclude_ou') )
			#TODO enable this feature
		end

		respond_to do |f|
			f.html {
				@contacts = @contacts.page(params[:page])
				render :index}
			f.json { render json: @contacts }
		end

	end

	# GET /contacts/1
	# GET /contacts/1.json
	def show
		respond_to do |f|
			f.html { render :show}
			f.json { render json:  {
				contact: @contact,
				contactAddresses: @contact.address_contacts,
				addresses: @contact.addresses,
				phones: @contact.contact_phones,
				emails: @contact.contact_emails  } }
		end

	end

	# GET /contacts/new
	def new
		@contact = Contact.new
		@contact.contact_emails.build
		@contact.contact_phones.build
		@contact.address_contacts.build(address: Address.new)
	end

	# GET /contacts/1/edit
	def edit
	end

	# POST /contacts
	# POST /contacts.json
	def create
		@contact = Contact.new(contact_params)
		respond_to do |format|
			if @contact.save
				format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
				format.json { json_success }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { json_failure @contact.errors }
			end

		end

	end

	# PATCH/PUT /contacts/1
	# PATCH/PUT /contacts/1.json
	def update
		respond_to do |format|
			if @contact.update(contact_params)
				format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
				format.json { json_success }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { json_failure @contact.errors }
			end

		end

	end

	# DELETE /contacts/1
	# DELETE /contacts/1.json
	def destroy
		@contact.destroy
		respond_to do |format|
			format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
			format.json { json_success }
		end

	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_contact
		@contact = Contact.includes(:address_contacts,:addresses).find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def contact_params
		params.require(:contact).permit(:fname, :lname, :mname, :description, :standing_id,
																		contact_phones_attributes: [:id, :number, :phone_type],
																		contact_emails_attributes: [:id, :address ],
																		address_contacts_attributes: [:id, :address_id, :contact_id, :delivery, :invoice,
																								address_attributes:[:id, :street1, :street2, :city, :postal_code, :state, :country, :status]])
	end
end
