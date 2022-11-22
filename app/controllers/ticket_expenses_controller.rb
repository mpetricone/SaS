class TicketExpensesController < ApplicationController
	before_action(only: [:new, :create]) { process_permission has_create_permission(:ticket_expense) }
	before_action(only: [:edit, :update]) { process_permission has_write_permission(:ticket_expense) }
	before_action(only: [:destroy]) { process_permission has_delete_permission(:ticket_expense) }

	def new
		populate_new
	end

	def create
		populate_new new_params

		respond_to do |f|
			if @ticket_expense.save
				f.html { redirect_to @ticket, notice:  t(:notice_added,item: TicketExpense.model_name.human)  }
				f.json { json_success }
			else
				f.html { render :new, status: :unprocessable_entity }
				f.json { json_failure @ticket_expense.errors }
			end

		end

	end

	def edit
		populate_edit

	end

	def update
		populate_edit

		respond_to do |f|
			if @ticket_expense.update new_params
				f.html { redirect_to @ticket, notice:  t(:notice_updated, item: TicketExpense.model_name.human)  }
				f.json { json_success }
			else
				f.html { render :edit, status: :unprocessable_entity }
				f.json { json_failure @ticket_expense.errors }
			end

		end

	end

	def destroy
		populate_edit

		respond_to do |f|
			if @ticket_expense.destroy
				f.html { redirect_to @ticket, notice: t(:notice_removed, item: TicketExpense.model_name.human)  }
				f.json { json_success }
			else
				f.html { redirect_to @ticket, alert: t(:alert_not_removed, item: TickeExpense.model_name.human)  }
				f.json { json_failure @ticket_expense.errors }
			end

		end

	end

	def new_params
		params.require(:ticket_expense).permit(:id, :ticket_id, :employee_id, :cost, :date_incurred, :note, :expense_type_id)
	end

	def populate_new fill = nil
		if fill
			@ticket_expense = TicketExpense.new new_params
		else
			@ticket_expense = TicketExpense.new
		end

		@ticket = Ticket.find params[:ticket_id]
		@ticket_expense.ticket = @ticket
		@ticket_expense.employee = get_current_employee
	end

	def populate_edit
		@ticket_expense = TicketExpense.find params[:id]
		@ticket = Ticket.find params[:ticket_id]
		@ticket_expense.ticket = @ticket
	end
end
