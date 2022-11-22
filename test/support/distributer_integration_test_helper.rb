module DistributerIntegrationTestHelper
  def visit_distributers
    visit distributers_path
  end

  def find_distributer_details
    visit_distributers
    first("a", text: "Show").click
  end
end
