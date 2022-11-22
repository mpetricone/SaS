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
        retstr = "Amount Payed " +amt+"<br/>"
        if amt>cost
            retstr << "Overpayed by "+(-calculatePaymentDifference.to_f).to_s+"<br/>"
        elsif amt==cost
            retstr << "Payed In Full<br/>"
        else
            retstr << "Debt Outstanding " +calculatePaymentDifference+"<br/>"
        end
        return retstr.html_safe
    end
    
    def setPayedStatus
        @expense.update(paid: calculatePaymentDifference.to_f<=0 ? true : false)
    end
end
