class OuPaymentTypesController < ApplicationController
	before_action :set_ou_payment_type, only: [:show, :edit, :update, :destroy]
	before_action(only: [:show, :index]) { process_permission has_read_permission(:expense_attribute) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:expense_attribute) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:expense_attribute) }
	before_action(only: [:delete]) {process_permission has_delete_permission(:expense_attribute) }

	# GET /ou_payment_types
	# GET /ou_payment_types.json
	def index
		respond_to do |f|
			f.html {
				@ou_payment_types = OuPaymentType.page(params[:page])
				render :index
			}
			f.json { render json: OuPaymentType.all }
		end

	end

	def search_by_name
		where_name = "%#{params[:search_name]}%"
		@ou_payment_types = OuPaymentType.where('name like ? or method like ?', where_name, where_name)

		respond_to do |f|
			f.html {
				@ou_payment_types = @ou_payment_types.page params[:page]
				render :index
			}
			f.json { render json: @ou_payment_types }
		end

	end

	# GET /ou_payment_types/1
	# GET /ou_payment_types/1.json
	def show
	end

	# GET /ou_payment_types/new
	def new
		@ou_payment_type = OuPaymentType.new
	end

	# GET /ou_payment_types/1/edit
	def edit
	end

	# POST /ou_payment_types
	# POST /ou_payment_types.json
	def create
		@ou_payment_type = OuPaymentType.new(ou_payment_type_params)

		respond_to do |f|
			if @ou_payment_type.save
				f.html { redirect_to @ou_payment_type, notice: 'Ou payment type was successfully created.' }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @ou_payment_type.errors }
			end

		end

	end

	# PATCH/PUT /ou_payment_types/1
	# PATCH/PUT /ou_payment_types/1.json
	def update
		respond_to do |f|
			if @ou_payment_type.update(ou_payment_type_params)
				f.html { redirect_to @ou_payment_type, notice: 'Ou payment type was successfully updated.' }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @ou_payment_types.errors }
			end

		end

	end

	# DELETE /ou_payment_types/1
	# DELETE /ou_payment_types/1.json
	def destroy
		@ou_payment_type.destroy
		respond_to do |f|
			f.html { redirect_to ou_payment_types_url, notice: 'Ou payment type was successfully destroyed.' }
			f.json { json_success }
		end

	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_ou_payment_type
		@ou_payment_type = OuPaymentType.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def ou_payment_type_params
		params.require(:ou_payment_type).permit(:id, :name, :date_enabled, :date_retired, :method, :info, :ou_id)
	end
end
