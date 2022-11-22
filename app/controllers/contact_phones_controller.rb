class ContactPhonesController < ApplicationController
	before_action(only: [:show, :index]) { process_permission has_read_permission(:distributer_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:distributer_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:distributer_attribute) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:distributer_attribute) }

	before_action :set_contact_phone, only: [ :edit, :update, :destroy]

	# GET /contact_phones/new
	def new
		@contact_phone = ContactPhone.new
		@contact = Contact.find params[:contact_id]
		@contact_phone.contact = @contact
	end

	# GET /contact_phones/1/edit
	def edit
		@contact = Contact.find params[:contact_id]
	end

	# POST /contact_phones
	# POST /contact_phones.json
	def create
		@contact_phone = ContactPhone.new(new_contact_phone_params)
		@contact = Contact.find params[:contact_id]
		@contact_phone.contact = @contact

		respond_to do |format|
			if @contact_phone.save
				format.html { redirect_to @contact, notice: 'Contact phone was successfully created.' }
				format.json { json_success }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { json_failure }
			end

		end

	end

	# PATCH/PUT /contact_phones/1
	# PATCH/PUT /contact_phones/1.json
	def update
		@contact = Contact.find params[:contact_id]
		@contact_phone.contact = @contact
		respond_to do |format|
			if @contact_phone.update(contact_phone_params)
				format.html { redirect_to @contact, notice: 'Contact phone was successfully updated.' }
				format.json { json_success }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { json_failure }
			end

		end

	end

	# DELETE /contact_phones/1
	# DELETE /contact_phones/1.json
	def destroy
		@contact = Contact.find params[:contact_id]
		@contact_phone.destroy
		respond_to do |format|
			format.html { redirect_to @contact, notice: 'Contact phone was successfully removed.' }
			format.json { json_success }
		end

	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_contact_phone
		@contact_phone = ContactPhone.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def contact_phone_params
		params.require(:contact_phone).permit(:number, :phone_type )
	end

	def new_contact_phone_params
		params.require(:contact_phone).permit(:id, :number, :phone_type, :contact_id)
	end
end
