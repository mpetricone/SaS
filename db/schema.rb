# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_05_192701) do
  create_table "active_storage_attachments", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "address_clients", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "address_id"
    t.bigint "client_id"
    t.boolean "delivery"
    t.boolean "invoice"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["address_id"], name: "index_address_clients_on_address_id"
    t.index ["client_id"], name: "index_address_clients_on_client_id"
  end

  create_table "address_contacts", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "contact_id"
    t.bigint "address_id"
    t.boolean "delivery"
    t.boolean "invoice"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["address_id"], name: "index_address_contacts_on_address_id"
    t.index ["contact_id"], name: "index_address_contacts_on_contact_id"
  end

  create_table "address_distributers", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "address_id"
    t.bigint "distributer_id"
    t.boolean "invoice"
    t.boolean "delivery"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["address_id"], name: "index_address_distributers_on_address_id"
    t.index ["distributer_id"], name: "index_address_distributers_on_distributer_id"
  end

  create_table "addresses", charset: "utf8mb4", force: :cascade do |t|
    t.string "street1"
    t.string "street2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.integer "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "authenticity_tokens", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "employee_id"
    t.string "token"
    t.datetime "time_invalid", precision: nil
    t.boolean "is_valid"
    t.integer "ttl"
    t.string "reason"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_authenticity_tokens_on_employee_id"
  end

  create_table "client_contacts", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_contacts_on_client_id"
    t.index ["contact_id"], name: "index_client_contacts_on_contact_id"
  end

  create_table "client_emails", charset: "utf8mb4", force: :cascade do |t|
    t.string "email"
    t.string "description"
    t.bigint "client_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_emails_on_client_id"
  end

  create_table "client_notes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "client_id"
    t.text "note"
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_notes_on_client_id"
  end

  create_table "client_phones", charset: "utf8mb4", force: :cascade do |t|
    t.string "number"
    t.string "description"
    t.bigint "client_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_phones_on_client_id"
  end

  create_table "client_rates", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "rate_id"
    t.boolean "current"
    t.date "date_implemented"
    t.date "date_retired"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_rates_on_client_id"
    t.index ["rate_id"], name: "index_client_rates_on_rate_id"
  end

  create_table "clients", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.bigint "standing_id"
    t.boolean "refuse"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "default_invoice_id"
    t.integer "default_delivery_id"
    t.string "tax_exemption"
    t.index ["standing_id"], name: "index_clients_on_standing_id"
  end

  create_table "contact_distributers", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "contact_id"
    t.bigint "distributer_id"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["contact_id"], name: "index_contact_distributers_on_contact_id"
    t.index ["distributer_id"], name: "index_contact_distributers_on_distributer_id"
  end

  create_table "contact_emails", charset: "utf8mb4", force: :cascade do |t|
    t.string "address"
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["contact_id"], name: "index_contact_emails_on_contact_id"
  end

  create_table "contact_phones", charset: "utf8mb4", force: :cascade do |t|
    t.string "number"
    t.string "phone_type"
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["contact_id"], name: "index_contact_phones_on_contact_id"
  end

  create_table "contacts", charset: "utf8mb4", force: :cascade do |t|
    t.string "fname"
    t.string "lname"
    t.string "mname"
    t.string "description"
    t.bigint "standing_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["standing_id"], name: "index_contacts_on_standing_id"
  end

  create_table "distributer_emails", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "distributer_id"
    t.string "email"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["distributer_id"], name: "index_distributer_emails_on_distributer_id"
  end

  create_table "distributer_phones", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "distributer_id"
    t.string "number"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["distributer_id"], name: "index_distributer_phones_on_distributer_id"
  end

  create_table "distributer_products", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "distributer_id"
    t.bigint "product_id"
    t.string "current_cost"
    t.string "dist_item_number"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["distributer_id"], name: "index_distributer_products_on_distributer_id"
    t.index ["product_id"], name: "index_distributer_products_on_product_id"
  end

  create_table "distributers", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "min_purchase"
    t.string "min_purchase_freq"
    t.date "date_enabled"
    t.date "date_disabled"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "employee_permissions", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "permission_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_employee_permissions_on_employee_id"
    t.index ["permission_id"], name: "index_employee_permissions_on_permission_id"
  end

  create_table "employees", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "contact_id"
    t.bigint "ou_id"
    t.date "date_hired"
    t.string "position"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "user_name"
    t.string "password_digest"
    t.index ["contact_id"], name: "index_employees_on_contact_id"
    t.index ["ou_id"], name: "index_employees_on_ou_id"
    t.index ["user_name"], name: "index_employees_on_user_name"
  end

  create_table "expense_payments", charset: "utf8mb4", force: :cascade do |t|
    t.string "amount"
    t.string "identifier"
    t.bigint "ou_payment_type_id"
    t.bigint "expense_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "date_payed"
    t.index ["expense_id"], name: "index_expense_payments_on_expense_id"
    t.index ["ou_payment_type_id"], name: "index_expense_payments_on_ou_payment_type_id"
  end

  create_table "expense_types", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "expenses", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "cost"
    t.date "date_incurred"
    t.text "description"
    t.boolean "paid"
    t.string "invoice_number"
    t.bigint "ou_id"
    t.bigint "employee_id"
    t.bigint "expense_type_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_expenses_on_employee_id"
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id"
    t.index ["ou_id"], name: "index_expenses_on_ou_id"
  end

  create_table "ou_addresses", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ou_id"
    t.bigint "address_id"
    t.boolean "delivery"
    t.boolean "invoice"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["address_id"], name: "index_ou_addresses_on_address_id"
    t.index ["ou_id"], name: "index_ou_addresses_on_ou_id"
  end

  create_table "ou_emails", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ou_id"
    t.string "address"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ou_id"], name: "index_ou_emails_on_ou_id"
  end

  create_table "ou_payment_types", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.date "date_enabled"
    t.date "date_retired"
    t.string "method"
    t.text "info"
    t.bigint "ou_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ou_id"], name: "index_ou_payment_types_on_ou_id"
  end

  create_table "ou_phones", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ou_id"
    t.string "number"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ou_id"], name: "index_ou_phones_on_ou_id"
  end

  create_table "ous", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "root_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "tax_id"
    t.index ["root_id"], name: "index_ous_on_root_id"
    t.index ["tax_id"], name: "index_ous_on_tax_id"
  end

  create_table "permissions", charset: "utf8mb4", force: :cascade do |t|
    t.boolean "read_record"
    t.boolean "write_record"
    t.boolean "create_record"
    t.boolean "delete_record"
    t.string "name"
    t.string "object_name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "admin"
    t.index ["name"], name: "index_permissions_on_name", unique: true
    t.index ["object_name"], name: "index_permissions_on_object_name"
  end

  create_table "product_notes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.string "title"
    t.text "note"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id"], name: "index_product_notes_on_product_id"
  end

  create_table "product_tickets", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "product_id"
    t.datetime "date_sold", precision: nil
    t.string "price"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "quantity"
    t.index ["product_id"], name: "index_product_tickets_on_product_id"
    t.index ["ticket_id"], name: "index_product_tickets_on_ticket_id"
  end

  create_table "products", charset: "utf8mb4", force: :cascade do |t|
    t.string "base_cost"
    t.string "item_number"
    t.string "sku"
    t.string "name"
    t.text "description"
    t.string "category"
    t.string "manufacturer"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "rates", charset: "utf8mb4", force: :cascade do |t|
    t.string "rate"
    t.boolean "current"
    t.date "date_implemented"
    t.date "date_retired"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "shipment_trackings", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id"
    t.string "tracking_number"
    t.datetime "date_shipped", precision: nil
    t.integer "item_count"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ticket_id"], name: "index_shipment_trackings_on_ticket_id"
  end

  create_table "standings", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "taxes", charset: "utf8mb4", force: :cascade do |t|
    t.decimal "rate", precision: 16, scale: 6
    t.string "name"
    t.datetime "date_enabled", precision: nil
    t.datetime "date_retired", precision: nil
    t.string "region"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ticket_action_statuses", charset: "utf8mb4", force: :cascade do |t|
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ticket_actions", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "action_status_id"
    t.bigint "employee_id"
    t.datetime "date_taken", precision: nil
    t.string "action"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["action_status_id"], name: "index_ticket_actions_on_action_status_id"
    t.index ["employee_id"], name: "index_ticket_actions_on_employee_id"
    t.index ["ticket_id"], name: "index_ticket_actions_on_ticket_id"
  end

  create_table "ticket_expenses", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "expense_type_id"
    t.bigint "employee_id"
    t.decimal "cost", precision: 16, scale: 2
    t.string "note"
    t.datetime "date_incurred", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_ticket_expenses_on_employee_id"
    t.index ["expense_type_id"], name: "index_ticket_expenses_on_expense_type_id"
    t.index ["ticket_id"], name: "index_ticket_expenses_on_ticket_id"
  end

  create_table "ticket_infos", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "employee_id"
    t.text "info"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_ticket_infos_on_employee_id"
    t.index ["ticket_id"], name: "index_ticket_infos_on_ticket_id"
  end

  create_table "ticket_notes", charset: "utf8mb4", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.bigint "ticket_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_notes_on_ticket_id"
  end

  create_table "ticket_payments", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id"
    t.string "payment"
    t.date "date_received"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ticket_id"], name: "index_ticket_payments_on_ticket_id"
  end

  create_table "ticket_pictures", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id", null: false
    t.text "description"
    t.datetime "taken_at"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_pictures_on_ticket_id"
  end

  create_table "ticket_statuses", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ticket_times", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id"
    t.date "date"
    t.time "time_start"
    t.time "time_end"
    t.string "hours"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ticket_id"], name: "index_ticket_times_on_ticket_id"
  end

  create_table "ticket_work_types", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "work_type_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ticket_id"], name: "index_ticket_work_types_on_ticket_id"
    t.index ["work_type_id"], name: "index_ticket_work_types_on_work_type_id"
  end

  create_table "tickets", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "contact_id"
    t.bigint "employee_id"
    t.bigint "rate_id"
    t.bigint "ticket_status_id"
    t.string "cost_parts"
    t.datetime "date_created", precision: nil
    t.datetime "date_resolved", precision: nil
    t.string "short_description"
    t.boolean "billing_hourly"
    t.boolean "billing_fixed"
    t.string "billing_fixed_value"
    t.boolean "payment_requested"
    t.boolean "payment_received"
    t.datetime "invoice_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "default_invoice_id"
    t.integer "default_delivery_id"
    t.integer "ou_address_id"
    t.bigint "ou_id"
    t.boolean "payed_in_full"
    t.string "tax"
    t.decimal "tax_rate", precision: 16, scale: 6
    t.string "sale_cost"
    t.boolean "taxable"
    t.string "tax_exemption"
    t.boolean "taxable_labor"
    t.string "field_location"
    t.bigint "tax_id"
    t.index ["client_id"], name: "index_tickets_on_client_id"
    t.index ["contact_id"], name: "index_tickets_on_contact_id"
    t.index ["employee_id"], name: "index_tickets_on_employee_id"
    t.index ["ou_id"], name: "index_tickets_on_ou_id"
    t.index ["rate_id"], name: "index_tickets_on_rate_id"
    t.index ["tax_id"], name: "index_tickets_on_tax_id"
    t.index ["ticket_status_id"], name: "index_tickets_on_ticket_status_id"
  end

  create_table "work_types", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authenticity_tokens", "employees"
  add_foreign_key "ticket_expenses", "employees"
  add_foreign_key "ticket_expenses", "expense_types"
  add_foreign_key "ticket_expenses", "tickets"
  add_foreign_key "ticket_notes", "tickets"
  add_foreign_key "ticket_pictures", "tickets"
  add_foreign_key "tickets", "taxes"
end
