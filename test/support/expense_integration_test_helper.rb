module ExpenseIntegrationTestHelper
  def visit_expenses_page
    visit "/expenses"
  end

  def find_expense_page
    visit "/expenses"
    first("a", text: "Show").click
  end
end
