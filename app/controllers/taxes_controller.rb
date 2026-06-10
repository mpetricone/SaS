class TaxesController < ApplicationController
  before_action { authorize Tax }

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
				format.html { redirect_to taxes_path, notice: t(:notice_added, item: Tax.model_name.human) }
				format.json { json_success }
			else
				format.html { render :new, status: :unprocessable_content }
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
				format.html { redirect_to @tax, notice: t(:notice_updated, item: Tax.model_name.human) }
				format.json { json_success }
			else
				format.html { render :edit, status: :unprocessable_content }
				format.json { json_failure @tax.errors }
			end

		end

	end

	def destroy
		populate_edit
		name = @tax.name;
		respond_to do |format|
			if @tax.destroy
				format.html { redirect_to taxes_path, notice: t(:notice_removed, item: Tax.model_name.human)}
				format.json { json_success }
			else
				format.html { redirect_to taxes_path, alert: t(:alert_not_removed, item: Tax.model_name.human) }
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
