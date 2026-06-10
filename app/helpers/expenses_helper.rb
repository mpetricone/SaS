module ExpensesHelper
    #TODO: these should probably be in the model
    def calculateAmountPayed
        j = 0;
        @expense.expense_payments.each { |p| j+=p.amount.to_f }
        return number_with_precision(j, precision: 2)
    end

    def calculatePaymentDifference
        return number_with_precision(@expense.cost.to_f-calculateAmountPayed.to_f, precision: 2)
    end
    def getPaymentInfo
        amt=calculateAmountPayed
        cost = number_with_precision(@expense.cost.to_f, precision: 2)
        retstr = I18n.t(:label_amount_paid_html, amount: amt) + "<br/>"
        if amt>cost
            retstr << I18n.t(:label_overpaid_by_html, amount: -calculatePaymentDifference.to_f) + "<br/>"
        elsif amt==cost
            retstr << I18n.t(:label_paid_in_full) + "<br/>"
        else
            retstr << I18n.t(:label_debt_outstanding_html, amount: calculatePaymentDifference) + "<br/>"
        end
        return retstr.html_safe
    end
    
    def setPayedStatus
        @expense.update(paid: calculatePaymentDifference.to_f<=0 ? true : false)
    end
end
