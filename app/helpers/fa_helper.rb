module FaHelper
  def ficon(ic, text = '', st = 'fa-solid', cl = '')
    "<i class='#{st} fa-#{ic} #{cl}'></i> #{text}".html_safe
  end
end
