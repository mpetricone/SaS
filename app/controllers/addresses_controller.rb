class AddressesController < ApplicationController
	before_action(only: [ :index, :show, :search_by_name]) { process_permission has_read_permission(:address) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:address) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:address) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:address) }

	def index
		respond_to do |f|
			f.html {
				@addresses = Address.page(params[:page]);
				render :index
			}
			f.json {
				@addresses = Address.all
				render json:  @address
			}
		end

	end

	def new
		@address = Address.new
	end

	def create
		@address = Address.new(address_params)
		respond_to do |f|
			if @address.save
				f.html { redirect_to @address }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity}
				f.html { json_failure @address.errors }
			end

		end

	end

	def search_by_name
		where_name = "%#{params[:search_name]}%"
		@addresses = Address.where('street1 like ? or street2 like ? or city like ? or state like ? or country like ? or postal_code like ?',
															 where_name, where_name, where_name, where_name, where_name, where_name)
		respond_to do |f|
			f.html {
				@addresses = @addresses.page params[:page]
				render :index
			}
			f.json { render json: @addresses }
		end

	end

	def edit
		@address = Address.find params[:id]

	end

	def show
		@address = Address.find(params[:id])
	end

	def update
		@address = Address.find(params[:id])

		respond_to do |f|
			if @address.update address_params
				f.html { redirect_to @address }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity}
				f.json { json_failure @address.errors }
			end

		end

	end

	def destroy
		@address = Address.find(params[:id])
		@address.destroy
		respond_to do |format|
			format.html { redirect_to  addresses_url, notice: "Record destroyed." }
			format.json { json_success }
		end

	end

	private

	def address_params
		params.require(:address).permit( :street1, :street2, :city, :state, :postal_code, :country, :status)
	end
end
