module TicketPaymentsHelper
  # DEPRECIATEDi=>START: whole module please do not use
  # These methods have been moved to app/models/ticket.rb
  def calculate_total_payments ticket
    warn "DEPRECIATED: use app/models/ticket.rb"
    total =0
    ticket.ticket_payments.each { |t| total+=  t.payment.to_f }
    return number_with_precision(total, precision: 2).to_f
  end

  def get_outstanding_balance ticket
    warn "DEPRECIATED: use app/models/ticket.rb :outstanding_balance"
    calculate_totals(ticket)[:final]-calculate_total_payments(ticket)
  end

  def is_ticket_payed_in_full ticket
    warn "DEPRECIATED: use_app/models/ticket.rb :payed_in_full?"
    calculate_totals(ticket)[:final] > calculate_total_payments(ticket) ?  false : true
  end
  # DEPRECIATED=>END

end
