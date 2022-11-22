class DistributersController < ApplicationController
	before_action(only: [:index, :show, :search_by_name]) { process_permission has_read_permission(:distributer) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:distributer) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:distributer) }
	before_action(only: [:delete]) { process_permission has_delete_permission(:distributer) }
	def index
		respond_to do |f|
			f.html {
				@distributers = Distributer.page(params[:page])
				render :index
			}
			f.json { render json: Distributer.all }
		end

	end

	def show
		@distributer = Distributer.find params[:id]
		respond_to do |f|
			f.html { render :show }
			f.json { render json: {
				distributer: @distributer,
				address_distributers: @distributer.address_distributers,
				addresses: @distributer.addresses,
				contact_distributers: @distributer.contact_distributers,
				contacts: @distributer.contacts,
				distributer_emails: @distributer.distributer_emails,
				distributer_phones: @distributer.distributer_phones
			} }
		end

	end

	def search_by_name
		@distributers = Distributer.where('name like ?', "%#{params[:search_name]}%")

		respond_to do |f|
			f.html {
				@distributers = @distributers.page(params[:page])
				render :index
			}
			f.json { render json: @distributers }
		end

	end

	def new
		@distributer = Distributer.new
		@distributer.address_distributers.build(address: Address.new)
		@distributer.contact_distributers.build
		@distributer.distributer_phones.build
		@distributer.distributer_emails.build
	end

	def create
		@distributer = Distributer.new new_params

		respond_to do |f|
			if @distributer.save
				f.html { redirect_to distributers_path, notice:  "Created #{Distributer.model_name.human} #{@distributer.name}." }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @distributer.errors }
			end

		end

	end

	def edit
		@distributer = Distributer.find params[:id]
	end

	def update
		@distributer = Distributer.find params[:id]

		respond_to do |f|
			if @distributer.update new_params
				f.html { redirect_to @distributer, notice: "Changes to #{@distributer.name} saved." }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @distributer.errors }
			end

		end

	end

	def destroy
		@distributer = Distributer.find params[:id]
		@distributer.destroy

		respond_to do |f|
			f.html { redirect_to distributers_path, notice: "Removed #{Distributer.model_name.human}" }
			f.json { json_success }
		end

	end

	private
	def new_params
		params.require(:distributer).permit(:id, :name,  :min_purchase, :min_purchase_freq, :date_enabled, :date_disabled,
																				address_distributers_attributes: [:id, :address_id, :distributer__id, :delivery, :invoice,
																											address_attributes: [:id, :street1, :street2, :city, :postal_code, :state, :country, :status]],
		contact_distributers_attributes: [:id, :distributer_id, :contact_id, :description ],
		distributer_phones_attributes: [:id, :number, :description],
		distributer_emails_attributes: [:id, :email, :description ] )
	end
end
