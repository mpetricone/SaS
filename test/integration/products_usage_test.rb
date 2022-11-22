require "test_helper"

class ProductsUsageTest < ActionDispatch::IntegrationTest
  def setup
    logon_admin
  end
  
  def visit_products_page
    visit products_path
  end

  def find_product_details 
    visit_products_page
    first('tbody tr a', text: 'Show').click
  end

  test "can use and create product" do
    visit_products_page
    page.assert_current_path products_path
    assert page.has_content? 'Search Products'

    click_link 'New Product'
    page.assert_current_path new_product_path
    assert page.has_content? 'New Product'
    fill_in 'Name', with: 'a thing'
    fill_in 'Base cost', with: '10.00'
    fill_in 'Category', with: 'something vaguer than "a thing"'
    fill_in 'Manufacturer', with: 'a Company'
    fill_in 'Item number', with: '81819227000029'
    fill_in 'Sku', with: 'HOPEFULLYUNIQUE112234'
    fill_in 'product_description', with: 'something we might want to sell'
    fill_in 'distributer-search', with: 'Distributer'
    fill_in 'Distributer item number', with: 'DINUM12344' #hopefully unique
    fill_in 'Current cost', with: '10.00'
    click_button 'Save'
    page.assert_current_path /\/products\/[0-9]*$/
    assert page.has_content? /#{Product.model_name.human} .* added\./
    dismiss_notice
    click_link 'Return'
    page.assert_current_path products_path
  end

  test "can edit and use products" do
    visit_products_page
    first('tbody tr a', text: 'Edit').click
    page.assert_current_path /\/products\/[0-9]*\/edit$/
    assert page.has_content? 'Editing Product'
    click_button "Save"
    page.assert_current_path /\/products\/[0-9]*$/
    assert page.has_content? /#{Product.model_name.human} .* updated\./
    dismiss_notice
    click_link 'Return'
    page.assert_current_path products_path
    first('tbody tr a', text: 'Delete').click
    accept_alert /Really delete Product .*\?/
    assert page.has_content? "#{Product.model_name.human} removed."
  end
  
  test "can use distributer products" do
    find_product_details

    page.assert_current_path /\/products\/[0-9]*$/
    
    click_link 'New Distributer product'
    page.assert_current_path /\/products\/[0-9]*\/distributer_products\/new$/
    assert page.has_content? 'New Distributer product for '
    fill_in 'Current cost', with: '100.00'
    fill_in 'Distributer item number', with: 'SHOULDBEUNIQUE100'
    click_button 'Save'
    page.assert_current_path /\/products\/[0-9]*$/
    assert page.has_content? /.* added to .*\.$/

    find(".card", text: 'Distributer product')
      .first('a', text: 'Edit')
      .click
    page.assert_current_path /\/products\/[0-9]*\/distributer_products\/[0-9]*\/edit$/
    click_button 'Save'
    page.assert_current_path /\/products\/[0-9]*$/
    assert page.has_content? /.* altered succesfully.$/

    find(".card", text: 'Distributer product')
      .first('a', text: 'Remove')
      .click
    accept_alert 'Really delete Distributer product?'
    assert page.has_content? "#{DistributerProduct.model_name.human} deleted."
  end

  test "can use product note" do
    find_product_details

    click_link 'New Product note'
    page.assert_current_path /\/products\/[0-9]*\/product_notes\/new/
    assert page.has_content? /New Product note for .*$/
    fill_in 'Title', with: 'a note'
    fill_in 'Note', with: 'hey there, what is going on?'
    click_button 'Save'
    page.assert_current_path /\/products\/[0-9]*$/
    assert page.has_content? /^#{ProductNote.model_name.human} .* added.$/

    find('.card', text: 'Product note')
      .first('a', text: 'Edit')
      .click
    page.assert_current_path /\/products\/[0-9]*\/product_notes\/[0-9]*\/edit$/
    assert page.has_content? /Edit Product note for .*$/
    click_button 'Save'
    page.assert_current_path /\/products\/[0-9]*$/
    assert page.has_content? /^#{ProductNote.model_name.human} .* updated.$/
    find('.card', text: 'Product note')
      .first('a', text: 'Remove')
      .click
    accept_alert "Really delete Product note?"
    assert page.has_content? "#{ProductNote.model_name.human} removed."
  end
    
end
