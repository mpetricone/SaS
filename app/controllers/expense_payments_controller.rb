class ExpensePaymentsController < ApplicationController
	before_action :set_expense_payment, only: [:show, :edit, :update, :destroy]
	before_action(only: [:show, :index]) { process_permission has_read_permission(:expense) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:expense) }
	before_action(only: [:new, :create]) { process_permission has_create_permission(:expense) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:expense) }


	# GET /expense_payments
	# GET /expense_payments.json
	def index
		@expense_payments = ExpensePayment.all
	end

	# GET /expense_payments/1
	# GET /expense_payments/1.json
	def show
	end

	# GET /expense_payments/new
	def new
		new_expense_payment
	end

	# GET /expense_payments/1/edit
	def edit
	end

	# POST /expense_payments
	# POST /expense_payments.json
	def create
		@expense_payment = ExpensePayment.new(expense_payment_params)
		set_expense
		respond_to do |format|
			if @expense_payment.save
				format.html { redirect_to @expense, notice: 'Expense payment was successfully created.' }
				format.json { json_success }
			else
				format.html { render :new, status: :unprocessable_entity }
				format.json { json_failure @expense_payment.errors }
			end

		end

	end

	# PATCH/PUT /expense_payments/1
	# PATCH/PUT /expense_payments/1.json
	def update
		set_expense
		respond_to do |format|
			if @expense_payment.update(expense_payment_params)
				format.html { redirect_to @expense, notice: 'Expense payment was successfully updated.' }
				format.json { json_success }
			else
				format.html { render :edit, status: :unprocessable_entity }
				format.json { json_failure @expense_payment.errors }
			end

		end

	end

	# DELETE /expense_payments/1
	# DELETE /expense_payments/1.json
	def destroy
		@expense_payment.destroy
		respond_to do |format|
			format.html { redirect_to @expense, notice: 'Expense payment was successfully removed.' }
			format.json { json_success }
		end

	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_expense_payment
		@expense_payment = ExpensePayment.find(params[:id])
		set_expense
	end

	def set_expense
		@expense = Expense.find(params[:expense_id])
		@expense_payment.expense = @expense;
	end

	def new_expense_payment
		@expense_payment = ExpensePayment.new
		@expense = Expense.find(params[:expense_id])
		@expense_payment.expense = @expense;
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def expense_payment_params
		params.require(:expense_payment).permit(:amount, :identifier,:date_payed, :ou_payment_type_id, :expense_id)
	end
end
