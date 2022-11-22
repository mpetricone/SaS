class Ticket < ActiveRecord::Base
	belongs_to :client
	belongs_to :contact
	belongs_to :employee
	belongs_to :rate
	belongs_to :ticket_status
	#belongs_to :ticket_type
	belongs_to :ticket_delivery_address, class_name: 'Address', foreign_key: "default_delivery_id", optional: true
	belongs_to :ticket_invoice_address, class_name: 'Address', foreign_key: "default_invoice_id", optional: true
	belongs_to :ticket_ou_address, class_name: 'Address', foreign_key: "ou_address_id", optional: true
	belongs_to :ou
	has_many :product_tickets
	has_many :ticket_work_types
	has_many :shipment_trackings
	has_many :ticket_infos
	has_many :ticket_action_statuses, through: :ticket_actions
	has_many :ticket_actions
	has_many :ticket_times
	has_many :ticket_payments
	has_many :ticket_pictures, dependent: :destroy
	has_many :ticket_notes, dependent: :destroy

	has_many :work_types, through: :ticket_work_types
	has_many :products, through: :product_tickets

	has_many :ticket_expenses, dependent: :destroy

	accepts_nested_attributes_for :ticket_infos
	accepts_nested_attributes_for :shipment_trackings
	accepts_nested_attributes_for :ticket_work_types
	accepts_nested_attributes_for :product_tickets

	validates :client, presence: true
	validates :ticket_status, presence: true
	validates :ou, presence: true

	def calculate_hours
		begin
			calculate_hours!
		rescue Exception => e
			e.message
		end

	end

	def calculate_hours!
		# cost: has been renamed hourly_cost:
		total = { hours: 0.0, hourly_cost: 0.0 }
		if billing_hourly
			self.ticket_times.each do |t|
				ct = t.time_end.to_f-t.time_start.to_f
				total[:hours]+=ct
				t.update hours: (ct/60/60).round(2)
			end

			total[:hours] = total[:hours]/60/60
			if !rate
				raise "No Rate, Please Edit Ticket and set a rate."
				total[:hourly_cost] = "No Rate, Please Edit Ticket and set a rate."
			else
				total[:hourly_cost] = (total[:hours]*self.rate.rate.to_f).round(2)
			end

		end
		# 2018-3-27
		total[:hours] = total[:hours].round(2) # this is here so as to not mess up existing calcs, should really before rate checka

		return total
	end

	def calculate_product_cost
		rv = 0.0
		self.product_tickets.each do |p|
			rv += p.quantity.to_i*p.price.to_f
		end

		return  rv.to_f().round(2)
	end

	def calculate_service_cost
		if self.billing_fixed
			return self.billing_fixed_value.to_f().round(2)
		end

		return 0.0
	end

	def calculate_labor_cost hourly_cost, service_cost
		if hourly_cost.is_a? String
			return hourly_cost
		end

		return ( hourly_cost+service_cost).round(2)
	end

	def calculate_expenses
		sum = 0

		ticket_expenses.each { |e| sum+=e.cost.to_f }
		return sum
	end

	def calculate_tax sub_total
		if !self.taxable
			return 0.0
		end

		tax = (self.tax_rate.to_f*sub_total[:product]).round(2)
		if self.taxable_labor
			tax += (self.tax_rate.to_f*sub_total[:labor]).round(2)
		end

		return tax
	end

	# new version of ticket_monetary calculation
	def calculate_totals
		total = {}
		begin
			# NOTE: this does not convert to strings, consider view helper for that.
			total = self.calculate_hours!
			# calculate_hours will return a string on error
			if (total.is_a? String)
				return total
			end

			total[:product] = calculate_product_cost
			total[:service] = calculate_service_cost
			total[:expenses] = calculate_expenses
			total[:labor] = calculate_labor_cost total[:hourly_cost], total[:service]
			total[:sub_net] = (total[:labor]+total[:product]).round(2) # total with no expenses or tax
			total[:sub] = (total[:labor]+total[:product]+total[:expenses]).round(2)
			total[:tax] = calculate_tax total
			total[:grand] = (total[:tax]+total[:sub]).round(2)
			total[:payments] = calculate_total_payments
			total[:outstanding] = outstanding_balance total
			total[:paid_in_full] = paid_in_full? total
			self.update sale_cost: total[:sub].to_s, tax: total[:tax].to_s
			total[:error] = 0
		rescue Exception => e
			total[:error] = e.message
		end

		return total
	end

	def calculate_total_payments
		total = 0.0
		self.ticket_payments.each { |t| total += t.payment.to_f }
		return total.round(2)
	end

	def outstanding_balance total
		(total[:grand]-calculate_total_payments).round(2)
	end

	def paid_in_full? total
		if (total[:grand] ) # TODO: what causes this to be missing or != 0 : could be dev data
			total[:grand] <= calculate_total_payments
		end

	end

	def invoice_or_ticket_date
		invoice_date ? invoice_date : created_at
	end

	def is_closed
		if !ticket_status
			return true
		end

		return (ticket_status.name==TicketStatus::SOLVED || ticket_status.name==TicketStatus::CLOSED)
	end
end
