class ExpensesController < ApplicationController
	before_action :set_expense, only: [:show, :edit, :update, :destroy]
	before_action(only: [:show, :index, :search_by_name]) {process_permission has_read_permission(:expense) }
	before_action(only: [:update, :edit]) { process_permission has_write_permission(:expense) }
	before_action(only: [:create, :new]) { process_permission has_create_permission(:expense) }
	before_action(only: [:delete]) { process_permission has_delete_permission(:expense) }

	# GET /expenses
	# GET /expenses.json
	def index
		respond_to do |f|
			f.html {
			@expenses = Expense.page(params[:page])
			render :index
			}
			f.json { render json: Expense.all }
		end

	end

	# GET /expenses/1
	# GET /expenses/1.json
	def show
	end

	# GET /expenses/new
	def new
		@expense = Expense.new
	end

	# GET /expenses/1/edit
	def edit
	end

	def search_by_name
		@expenses = Expense.where('name like ?', "%#{params[:search_name]}%")
		respond_to do |f|
			f.html {
				@expenses = @expenses.page(params[:page])
				render :index
			}
			f.json { render json: @expenses }
		end

	end

	# POST /expenses
	# POST /expenses.json
	def create
		@expense = Expense.new(expense_params)

		respond_to do |format|
			if @expense.save
				format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
				format.json { json_success }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { json_failure @expense.errors }
			end

		end

	end

	# PATCH/PUT /expenses/1
	# PATCH/PUT /expenses/1.json
	def update
		respond_to do |format|
			if @expense.update(expense_params)
				format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
				format.json { json_success }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { json_failure @expense.errors }
			end

		end

	end

	# DELETE /expenses/1
	# DELETE /expenses/1.json
	def destroy
		@expense.destroy
		respond_to do |format|
			format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
			format.json { json_success }
		end

	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_expense
		@expense = Expense.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def expense_params
		params.require(:expense).permit(:name, :cost, :date_incurred, :description, :paid, :invoice_number, :ou_id, :employee_id, :expense_type_id)
	end
end
