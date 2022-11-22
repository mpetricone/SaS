# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)
#   Following are records intended for production
# Ticket Actions
TicketActionStatus.create!(status: 'OK')
TicketActionStatus.create!(status: 'WATCH')
TicketActionStatus.create!(status: 'DONE')
TicketActionStatus.create!(status: 'INCOMPLETE')
TicketActionStatus.create!(status: 'WAIT')
TicketActionStatus.create!(status: 'OBSOLETE')
#Standings
Standing.create!(name: 'GOOD')
Standing.create!(name: 'POOR')
Standing.create!(name: 'PROBATION')
Standing.create!(name: 'REJECT')
# Ticket Statuses
TicketStatus.create!(name: 'ACTIVE')
TicketStatus.create!(name: 'SOLVED')
TicketStatus.create!(name: 'PAUSED')
TicketStatus.create!(name: 'AWAITING CUSTOMER RESPONSE')
TicketStatus.create!(name: 'WATCH')
# Work Types
WorkType.create!(name: 'MAINTENANCE')
WorkType.create!(name: 'VIRUS REMOVAL')
WorkType.create!(name: 'HARDWARE INSTALLATION')
WorkType.create!(name: 'SOFTWARE INSTALLATION')
WorkType.create!(name: 'INITIAL INSPECTION')
WorkType.create!(name: 'SECURITY EVALUATION')
WorkType.create!(name: 'SERVER INSTALLATION')
WorkType.create!(name: 'SERVER CONFIGURATION')
WorkType.create!(name: 'WORKSTATION CONFIGURATION')
WorkType.create!(name: 'E-MAIL CONFIGURATION')
WorkType.create!(name: 'NETWORK CONFIGURATON')
WorkType.create!(name: 'PRINTER MAINTENANCE')
WorkType.create!(name: 'PRINTER REPAIR')
WorkType.create!(name: 'NETWORK CONFIGURATION')
WorkType.create!(name: 'PHONE SYSTEMS SUPPORT')
WorkType.create!(name: 'STAFF ONSITE')
WorkType.create!(name: 'STAFF REMOTE')



# Standard Permissions
# 'Admin' is the System admin, and object_name 'all' is reserved for this Permission alone.
# 'Users' have all but delete for object_name, '___ Admin' have all perms for that object_name
# Any Permission with ' admin: true' is effectively a system admin! This will change in the future
# See permission.list for a list of used object_names, and their corresponding model names

permission_seeds = [
    # Name                        object                read    write   create  delete  admin
    ['Admin'                    , 'all',                    true,   true,   true,   true,   true ],
    ['Address Admin'            , 'address',                true,   true,   true,   true,   false],
    ['Address User'             , 'address',                true,   true,   true,   false,  false],
    ['Ou Admin'                 , 'ou',                     true,   true,   true,   true,   false],
    ['Ou User'                  , 'ou',                     true,   true,   true,   false,  false],
    ['Ou Attrib Admin'          , 'ou_attribute',           true,   true,   true,   true,   false],
    ['Ou Attrib User'           , 'ou_attribute',           true,   true,   true,   false,  false],
    ['Client Admin'             , 'client',                 true,   true,   true,   true,   false],
    ['Client User'              , 'client',                 true,   true,   true,   false,  false],
    ['Client Attrib Admin'      , 'client_attribute',       true,   true,   true,   true,   false],
    ['Client Attrib User'       , 'client_attribute',       true,   true,   true,   false,  false],
    ['Employee Admin'           , 'employee',               true,   true,   true,   true,   false],
    ['Employee User'            , 'employee',               true,   true,   true,   false,  false],
    ['Employee Permission Admin', 'permission_attribute',   true,   true,   true,   true,   false],
    ['Employee Permission User' , 'permission_attribute',   true,   true,   false,  false,  false],# I don't like the idea of a user with perm create ability    
    ['Distributer Admin'        , 'distributer',            true,   true,   true,   true,   false],
    ['Distributer User'         , 'distributer',            true,   true,   true,   false,  false],
    ['Distributer Attrib Admin' , 'distributer_attribute',  true,   true,   true,   true,   false],
    ['Distributer Attrib User'  , 'distributer_attribute',  true,   true,   true,   false,  false],
    ['Product Admin'            , 'product',                true,   true,   true,   true,   false],
    ['Product User'             , 'product',                true,   true,   true,   true,   false],
    ['Product Attrib Admin'     , 'product_attribute',      true,   true,   true,   true,   false],
    ['Product Attrib User'      , 'product_attribute',      true,   true,   true,   false,  false],
    ['Permission Admin'         , 'permission',             true,   true,   true,   true,   false],
    ['Ticket Admin'             , 'ticket',                 true,   true,   true,   true,   false],
    ['Ticket User'              , 'ticket',                 true,   true,   true,   false,  false],
    ['Ticket Attrib Admin'      , 'ticket_attribute',       true,   true,   true,   true,   false],
    ['Ticket Attrib User'       , 'ticket_attribute',       true,   true,   true,   false,  false],
    ['Ticket Payment Admin'     , 'ticket_payment',         true,   true,   true,   true,   false],
    ['Ticket Payment User'      , 'ticket_payment',         true,   false,  true,   false,  false], # default ticket_payment users cannot alter existing.
    ['Tax Admin'                , 'tax',                    true,   true,   true,   true,   false],
    ['Tax  User'                , 'tax',                    true,   true,   false,  false,  false], #Don't see the need to allow users to create new tax entries
    ['Expense Admin'            , 'expense',                true,   true,   true,   true,   false],
    ['Expense User'             , 'expense_attribute',      true,   false,  true,   false,  false]]
permission_seeds.each do |p|
    Permission.create!(name: p[0], object_name: p[1], read_record: p[2], write_record: p[3], create_record: p[4], delete_record: p[5], admin: p[6])
end
# The following records should be modified for the user prior to setup.
# Put the first contact here, to be used for the Initial admin account

# Addresses for employee and Ou
seed_ou_address = Address.create!(street1: REMOVED, street2: REMOVED, city: REMOVED, postal_code: REMOVED, country: REMOVED, status: 1)
seed_employee_address = seed_ou_address
employee_contact = Contact.create!( fname: REMOVED, lname: REMOVED, mname: 'S', description: "The Man", standing_id: Standing.find_by(name: "GOOD").id)
AddressContact.create!( contact_id: employee_contact.id, address_id: seed_employee_address.id, delivery: true, invoice: true)
# This should be the initial, primary OU
## Tax entry
tax = Tax.create!(rate: 0.07, name: 'NJ Standard', region: 'NJ', date_enabled: DateTime.now);

seed_ou = Ou.create!(name: "Main", description: "Primary OU", tax:  tax)
OuAddress.create!(ou_id: seed_ou.id, address_id: seed_ou_address.id, delivery: true, invoice: true)

# The initial admin, and it's admin permission
Employee.create!(contact_id: Contact.find_by(lname: REMOVED).id, ou_id: Ou.find_by(name: "Main").id, date_hired: "01-01-0001", position: "Owner", user_name: REMOVED, password: REMOVED, password_confirmation: REMOVED)
EmployeePermission.create!(employee_id: Employee.find_by(user_name: REMOVED).id, permission_id: Permission.find_by( name: 'Admin').id)

#***********************************************#
# Following are records intended for development#
#***********************************************#

#=begin
# Comment from here to file end for production
Address.create!(street1: REMOVED, street2: REMOVED, city: REMOVED, state: REMOVED, postal_code: REMOVED, country: REMOVED)
Address.create!(street1: "1 Gateway Center",city: "Newark", state: "New Jersey", postal_code: "07111", country: "USA")
Address.create!(street1: "77 Imaginary Ln.", city: 'Emerald City',state: 'Not Kansas', postal_code: '29143', country: 'OZ')

Ou.create!(name: "Secondary", description: "Secondary OU", root_id: Ou.find_by(name: "Main").id, tax: tax)

OuAddress.create!(ou_id: Ou.find_by(name: "Main").id, address_id: Address.find_by(city: "Newark").id)
OuAddress.create!(ou_id: Ou.find_by(name: "Secondary").id, address_id: Address.find_by(city: "Fort Camaro").id)
Ou.all.each_with_index do  |insert, i| 
    OuPhone.create!(number: i, description: "Phone # #{i}", ou_id: insert.id) 
    OuEmail.create!(address: "Email#{i}@co.com", description: "N.#{i}", ou_id: insert.id)
end

6.times { |i| Contact.create!(fname: "User ##{i}", lname: "Surname #{i}", description: "user #{i}", standing_id: Standing.find_by(name: "POOR").id) }
Contact.all.each_with_index do |insert, i|
    AddressContact.create!(address_id: Address.find_by(city: "Newark").id, contact_id: insert.id, delivery: 1, invoice: 1)
    ContactEmail.create!(address: "Email@#{i}.com", contact_id: insert.id)
    ContactPhone.create!(number: "n#{i}", phone_type: "Main", contact_id: insert.id)
end
10.times { |i| Rate.create!(rate: (i*10).to_s, current: true) }
5.times do  |i| 
    Client.new(name: "Client #{i}",standing_id: Standing.find_by(name: 'GOOD').id, 
    refuse: false, default_invoice_id: Address.find_by(city: 'Newark').id, default_delivery_id: Address.find_by(city: 'Newark').id).save(validate: false)
end
Client.new( name: 'Client Refused 1',standing_id: Standing.find_by(name: 'REJECT').id, refuse: true,
              default_invoice_id: Address.find_by(city: 'Newark').id, default_delivery_id: Address.find_by(city: 'Newark').id).save(validate: false)
Client.all.each_with_index do |insert, i|
    AddressClient.create!(address_id: Address.find_by(city: 'Newark').id, client_id: insert.id, delivery: true, invoice: true)
    ClientEmail.create!(client_id: insert.id, email: "#{insert.name}@client.com")
    ClientContact.create!(contact_id: Contact.find_by(lname: "Surname #{i}").id, client_id: insert.id)
    ClientPhone.create!(client_id: insert.id, number: "1#{i}2#{i}", description: 'Main');
    ClientPhone.create!(client_id: insert.id, number: '777666555', description: 'alt-clone');
    10.times { |i| ClientNote.create!(client_id: insert.id, title: "Title #{i}", note: "Note text #{i}") }
    ClientRate.create!(client_id: insert.id, rate_id: Rate.find_by(rate: (i*10).to_s).id, current: true, date_implemented: Date.today)
    ClientRate.create!(client_id: insert.id, rate_id: Rate.find_by(rate: '90').id, current:false, date_implemented: Date.today, date_retired: Date.today)
end
Distributer.create!(name: 'Test Distributer 1', min_purchase: '100', min_purchase_freq: 'Monthly', date_enabled: Date.today)
dist = Distributer.find(1)
ContactDistributer.create!(distributer_id: dist.id,contact_id: Contact.find_by(lname: 'Surname 5').id, description: 'test')
AddressDistributer.create!(distributer_id: dist.id, address_id: Address.find(2).id, delivery: true, invoice: true)
DistributerPhone.create!(distributer_id: dist.id, number: '1122334', description: 'bloop')
DistributerEmail.create!(distributer_id: dist.id, email: 'yarg@pirate.ship', description: 'probably not a pirate')
Product.create!(name: '1 TB HD', base_cost: '100.00', category: 'Hard Drive', manufacturer: 'Hard drivilator', sku: '1001', item_number: '1001-1', description: 'a HD')
prod = Product.find(1)
DistributerProduct.create!(distributer_id: dist.id, product_id: prod.id, dist_item_number: '1001-1-BOO', current_cost:'110.0')
Product.create(name: "3' CAT 6 Cable", base_cost: '3.00', category: 'Cable', manufacturer: 'K r Us', sku: '2', item_number: '2-2', description: 'a short cable')
prod = Product.find(2)
DistributerProduct.create!(distributer_id: dist.id, product_id: prod.id, dist_item_number: '2-2-BOP', current_cost: '4')
#=end
