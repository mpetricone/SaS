class TaxesController < ApplicationController
	before_action(only: [:show, :index, :search_by_name]) { process_permission has_read_permission(:tax) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:tax) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:tax) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:tax) }

	def index
		respond_to do |f|
			f.html {
				@taxes = Tax.page(params[:page])
				render :index
			}
			f.json {
				@taxes = Tax.all
				render json: @taxes
			}
		end

	end

	def search_by_name
		where_name = "%#{params[:search_name]}%"
		@taxes = Tax.where('name like ? or rate like ? or region like ?', where_name, where_name, where_name)

		respond_to do |f|
			f.html {
				@taxes = @taxes.page params[:page]
				render :index
			}
			f.json { render json: @taxes }
		end

	end

	def show
		populate_edit
	end

	def new
		@tax = Tax.new
	end

	def create
		populate_new new_params

		respond_to do | format|
			if @tax.save
				format.html { redirect_to taxes_path, notice: "#{Tax.model_name.human} #{Tax.human_attribute_name :rate} #{@tax.rate} added." }
				format.json { json_success }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { json_failure @tax.errors }
			end

		end

	end

	def edit
		populate_edit
	end

	def update
		populate_edit
		respond_to do | format|
			if @tax.update new_params
				format.html { redirect_to @tax, notice: "#{Tax.model_name.human} #{@tax.name} updated." }
				format.json { json_success }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { json_failure @tax.errors }
			end

		end

	end

	def destroy
		populate_edit
		name = @tax.name;
		respond_to do |format|
			if @tax.destroy
				format.html { redirect_to taxes_path, notice: "#{Tax.model_name.human} #{name} remove."}
				format.json { json_success }
			else
				forma.html { redirect_to taxes_path, notice: "Error removing #{Tax.model_name.human} #{name}." }
				format.json { json_failure @tax.errors }
			end

		end

	end

	private

	def new_params
		params.require(:tax).permit(:id, :name, :region, :rate, :date_enabled, :date_retired);
	end

	def populate_new fill = nil
		if fill
			@tax = Tax.new new_params
		else
			@tax = Tax.new
		end

	end

	def populate_edit
		@tax = Tax.find params[:id]
	end
end
