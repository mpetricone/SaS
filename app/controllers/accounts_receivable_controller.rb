class AccountsReceivableController < ApplicationController
	before_action(only: [:show, :index]) { process_permission has_read_permission(:accounting_restricted) }

	def index
		params[:start_date] = params[:end_date] = Time.now
	end

	def search
		@ar = []
		@total = 0.0
		Client.all.each do |c|
			car = c.accounts_receivable(params[:start_date], params[:end_date])
			if (car[:accounts].count >0)
				@ar.push( {client: c, ar: car[:accounts], tar: car[:total] } )
			end
			@total += car[:total]

		end

	end

	private

	def search_params
		require(:accounts_receivable).permit(:start_date, :end_date)
	end
end
