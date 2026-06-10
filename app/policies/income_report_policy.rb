class IncomeReportPolicy < ApplicationPolicy
  permission_name :income_report

  def report?     = read?
  def report_v2?  = read?
  def report_v3?  = read?
end
