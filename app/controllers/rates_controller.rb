class RatesController < ApplicationController
	before_action :set_rate, only: [:show, :edit, :update, :destroy]
	before_action(only: [:show, :index, :search_by_name]) { process_permission has_read_permission(:rate) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:rate) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:rate) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:rate) }

	# GET /rates
	# GET /rates.json
	def index
		respond_to do |f|
			f.html {
				@rates = Rate.page(params[:page])
				render :index
			}
			f.json {
				@rates = Rate.all
				render json: @rates
			}
		end

	end

	def search_by_name
		where_name = "%#{params[:search_name]}%"
		@rates = Rate.where('rate like ?', where_name)

		respond_to do |f|
			f.html {
				@rates = @rates.page params[:page]
				render :index
			}
			f.json { render json: @rates }
		end

	end

	# GET /rates/1
	# GET /rates/1.json
	def show
	end

	# GET /rates/new
	def new
		@rate = Rate.new
	end

	# GET /rates/1/edit
	def edit
	end

	# POST /rates
	# POST /rates.json
	def create
		@rate = Rate.new(rate_params)

		respond_to do |format|
			if @rate.save
				format.html { redirect_to @rate, notice: 'Rate was successfully created.' }
				format.json { json_success }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { json_failure @rate.errors }
			end

		end

	end

	# PATCH/PUT /rates/1
	# PATCH/PUT /rates/1.json
	def update
		respond_to do |format|
			if @rate.update(rate_params)
				format.html { redirect_to @rate, notice: 'Rate was successfully updated.' }
				format.json { json_success }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { json_failure @rate.errors }
			end

		end

	end

	# DELETE /rates/1
	# DELETE /rates/1.json
	def destroy
		@rate.destroy
		respond_to do |format|
			format.html { redirect_to rates_url, notice: 'Rate was successfully destroyed.' }
			format.json { json_success }
		end

	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_rate
		@rate = Rate.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def rate_params
		# I think having a member with the same name as model is an issue for simple JSON requests
		# TODO consider renaming rate::rate
		params.require(:rate).permit(:rate, :current, :date_implemented, :date_retired, :client_rates)
	end
end
