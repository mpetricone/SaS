class IncomeReportController < ApplicationController
	before_action(only: [:index]) { process_permission has_read_permission(:income_report) }


	def index
	end

	def report
		@dates = [ params[:search][:date_start], params[:search][:date_end]]
		@tickets = Ticket.where(created_at: params[:search][:date_start]..params[:search][:date_end])
		@expense_list = Expense.where(date_incurred: params[:search][:date_start]..params[:search][:date_end]);
		@expense_total = calcExpenseTotalsFromSource(@expense_list);
		@payments = @tickets.where(payment_received: true)
		respond_to do |format|
			format.js
		end

	end

	def report_v2
		@dates= [params[:search2][:date_start], params[:search2][:date_end]]
		ticket_payments = TicketPayment.where(date_received: params[:search2][:date_start]..params[:search2][:date_end])
		expenses = getExpenses(params[:search2][:date_start], params[:search2][:date_end])
		@expense_total = calcExpenseTotals(expenses)
		@expense_list = getExpensesFromPayments(expenses)
		#expenses = ExpensePayment.where(date_payed: params[:search2][:date_start]..params[:search2][:date_end])
		@payments = Array.new
		ticket_payments.each do |pay|
			@payments.push pay.ticket;
		end

		respond_to do |format|
			format.js
		end

	end

	def report_v3
		get_date_range
		@ticket_payments = TicketPayment.where(date_received: params[:search2][:date_start]..params[:search2][:date_end])
		expenses = getExpenses(params[:search2][:date_start], params[:search2][:date_end])
		@expense_total = calcExpenseTotals(expenses)
		@expense_list = getExpensesFromPayments(expenses)
		@payment_total = 0
		@tickets = Set.new
		@ticket_payments.each do |p|
			@payment_total += p.payment.to_f
			build_ticket_list_from_payment p
		end

		@profit_loss = @payment_total-@expense_total

		calculate_ticket_totals

		respond_to do |format|
			format.js
		end

	end

	private
=begin
	def calculate_ticket_totals
		@ticket_totals = {}
		@tickets.each do |t|
			@ticket_totals = @ticket_totals.merge(t.calculate_totals) do  |key, old, new|
				begin
					old+new
				rescue
					new
				end

			end

		end

	end

=end

	def calculate_ticket_totals
		@ticket_totals = {}
		@ticket_taxed_totals = {}
		@ticket_no_tax_totals = {}
		@tickets.each do |t|
			total = t.calculate_totals
			if (t.tax.to_f>0)
				@ticket_taxed_totals = merge_totals(@ticket_taxed_totals, total)
			else
				@ticket_no_tax_totals = merge_totals(@ticket_no_tax_totals, total)
			end

		end

		@ticket_totals = merge_totals(@ticket_totals, @ticket_taxed_totals)
		@ticket_totals = merge_totals(@ticket_totals, @ticket_no_tax_totals)
	end

	def merge_totals a,b
		a = a.merge(b) do | key, old, new|
			begin
				old+new
			rescue
				new
			end

		end

		return a
	end

	def build_ticket_list_from_payment payment
		@tickets.add payment.ticket
	end

	def get_date_range
		@dates= [params[:search2][:date_start], params[:search2][:date_end]]
	end

	def getExpenses(startD, endD)
		return ExpensePayment.where(date_payed: startD..endD)
	end

	def calcExpenseTotals(expenses)
		total = 0;
		expenses.each do |e|
			total += e.amount.to_f;
		end

		return total;
	end

	def calcExpenseTotalsFromSource(expenses)
		total = 0;
		expenses.each do |e|
			total += e.cost.to_f;
		end

		return total;
	end

	def getExpensesFromPayments(payments)
		expense_list = Array.new

		payments.each do |p|
			if not expense_list.include?(p.expense)
				expense_list.push(p.expense)
			end

		end

		return expense_list
	end
end
