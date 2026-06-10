class AddressContactsController < ApplicationController
  before_action { authorize AddressContact }

	before_action :populate_edit, only: [ :edit, :update, :destroy]

	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |format|
			if @address_contact.save
				format.html { redirect_to @contact, notice:  "Added #{AddressContact.model_name.human} #{@address_contact.address.name_short}." }
				format.json { json_success }
			else
				format.html { render :new, status: :unprocessable_content }
				format.json { json_failure @address_contact.errors }
			end

		end

	end

	def edit
	end

	def update
		respond_to do |format|
			if @address_contact.update new_params
				format.html { redirect_to @contact, notice: t(:notice_updated, item: AddressContact.model_name.human) }
				format.json { json_success }
			else
				format.html { render :edit, status: :unprocessable_content }
				format.json { json_failure }
			end

		end

	end

	def destroy
		respond_to do |format|
			if (@address_contact.delete)
				format.html { redirect_to @contact, notice: t(:notice_removed, item: AddressContact.model_name.human) }
				format.json { json_success }
			else
				format.html { redirect_to @contact, alert: t(:alert_not_removed, item: AddressContact.model_name.human) }
				formt.json { json_failure }
			end

		end

	end

	private

	def new_params
		params.require(:address_contact).permit(:id, :address_id, :contact_id, :delivery, :invoice,
																						address_attributes: [:id,:street1, :street2, :city, :postal_code, :state, :country, :status])
	end

	def populate_new fill = nil
		if fill
			@address_contact = AddressContact.new fill
		else
			@address_contact = AddressContact.new
      @address_contact.address = Address.new
		end

		@contact = Contact.find params[:contact_id]
		@address_contact.contact = @contact
	end

	def populate_edit
		@address_contact = AddressContact.find params[:id]
		@contact = Contact.find params[:contact_id]
		@address_contact.contact = @contact
	end
end
