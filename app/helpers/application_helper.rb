module ApplicationHelper
=begin
		# DEPRECIATED: use calculate hours from app/models/ticket.rb
		def calculate_hours ticket
				warn "\nDEPRECIATED: use calculate_hours from app/models/ticket.rb\n"+caller(0, 5).inspect+"\n"
				total = {hours: 0.0, cost: 0.0 }
				ticket.ticket_times.each do |t|
						cur_time = t.time_end.to_i-t.time_start.to_i
						total[:hours]+=cur_time
						if t.hours != cur_time
								if !(t.update hours: cur_time/60/60)
										return "Time Update Error"
								end

						end

				end

				total[:hours] = total[:hours]/60/60
				if !ticket.rate
						total[:cost] = "No Rate"
				else
						total[:cost] = total[:hours]*ticket.rate.rate.to_f
				end

				return total
		end

		# DEPRECIATED: use calculate_totals from app/models/ticket.rb
		def calculate_totals ticket
			warn "\nDEPRECIATED: use calculate_totals from app/models/ticket.rb\n"+caller(0, 5).inspect+"\n"
				total = calculate_hours ticket
				@tax = ticket.tax_rate
				if (total.is_a? String)
						return total
				end

				total[:product] = 0.0
				ticket.product_tickets.each do |prod|
						total[:product]+=prod.quantity.to_i*prod.price.to_f
				end

				total[:service] = 0
				if ticket.billing_fixed
						total[:service]+= ticket.billing_fixed_value.to_f
				end

				if !ticket.rate
						total[:labor] = 0
				else
						total[:labor] = number_with_precision(( total[:cost]+total[:service]), precision: 2).to_f
				end

				total[:product] = number_with_precision(total[:product], precision: 2).to_f
				total[:sub] = number_with_precision(( total[:labor]+total[:product]), precision: 2).to_f
				if ticket.taxable
						total[:tax] = number_with_precision(( @tax*total[:product]), precision: 2).to_f
						if ticket.taxable_labor
								total[:tax] += number_with_precision((@tax*total[:labor]), precision: 2).to_f
						end

				else
						total[:tax] = 0.0
				end

				total[:final] = number_with_precision(( total[:sub]+total[:tax]), precision: 2).to_f
				@ticket.update sale_cost: total[:sub].to_s
				@ticket.tax = total[:tax].to_s
				@ticket.update tax: total[:tax].to_s
				return total
		end

		def getTax ticket
				return ticket.tax_rate
		end

		def getTaxPercent ticket
				return  number_with_precision(getTax(ticket)*100).to_s+'%';
		end

		def dollarAmount value
				return '$'+number_with_precision(value, precision: 2)
		end

		def parseHour value
				return number_with_precision(value, precision: 2 )
		end

=end

	def page_title_for action, title, f
		render partial: 'shared/form_page_title', locals: { title: t(action, title: title, for: f) }
	end

	def page_title_new title
		page_title :title_new, title
	end

	def page_title_edit title
		page_title :title_edit, title
	end

	def page_title action, title
		render partial: 'shared/form_page_title', locals: { title: t(action, title: title) }
	end
end
