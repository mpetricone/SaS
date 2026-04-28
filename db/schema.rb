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

ActiveRecord::Schema[8.1].define(version: 2024_09_07_185219) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "address_clients", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "address_id"
    t.integer "client_id"
    t.datetime "created_at", precision: nil
    t.boolean "delivery"
    t.boolean "invoice"
    t.datetime "updated_at", precision: nil
    t.index ["address_id"], name: "index_address_clients_on_address_id"
    t.index ["client_id"], name: "index_address_clients_on_client_id"
  end

  create_table "address_contacts", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "address_id"
    t.integer "contact_id"
    t.datetime "created_at", precision: nil
    t.boolean "delivery"
    t.boolean "invoice"
    t.datetime "updated_at", precision: nil
    t.index ["address_id"], name: "index_address_contacts_on_address_id"
    t.index ["contact_id"], name: "index_address_contacts_on_contact_id"
  end

  create_table "address_distributers", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "address_id"
    t.datetime "created_at", precision: nil
    t.boolean "delivery"
    t.integer "distributer_id"
    t.boolean "invoice"
    t.datetime "updated_at", precision: nil
    t.index ["address_id"], name: "index_address_distributers_on_address_id"
    t.index ["distributer_id"], name: "index_address_distributers_on_distributer_id"
  end

  create_table "addresses", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "city"
    t.string "country"
    t.datetime "created_at", precision: nil
    t.string "postal_code"
    t.string "state"
    t.integer "status"
    t.string "street1"
    t.string "street2"
    t.datetime "updated_at", precision: nil
  end

  create_table "authenticity_tokens", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "employee_id"
    t.boolean "is_valid"
    t.string "reason"
    t.datetime "time_invalid", precision: nil
    t.string "token"
    t.integer "ttl"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_authenticity_tokens_on_employee_id"
  end

  create_table "client_contacts", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "client_id"
    t.integer "contact_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["client_id"], name: "index_client_contacts_on_client_id"
    t.index ["contact_id"], name: "index_client_contacts_on_contact_id"
  end

  create_table "client_emails", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "client_id"
    t.datetime "created_at", precision: nil
    t.string "description"
    t.string "email"
    t.datetime "updated_at", precision: nil
    t.index ["client_id"], name: "index_client_emails_on_client_id"
  end

  create_table "client_notes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "client_id"
    t.datetime "created_at", precision: nil
    t.text "note"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.index ["client_id"], name: "index_client_notes_on_client_id"
  end

  create_table "client_phones", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "client_id"
    t.datetime "created_at", precision: nil
    t.string "description"
    t.string "number"
    t.datetime "updated_at", precision: nil
    t.index ["client_id"], name: "index_client_phones_on_client_id"
  end

  create_table "client_rates", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "client_id"
    t.datetime "created_at", precision: nil
    t.boolean "current"
    t.date "date_implemented"
    t.date "date_retired"
    t.integer "rate_id"
    t.datetime "updated_at", precision: nil
  end

  create_table "clients", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "default_delivery_id"
    t.integer "default_invoice_id"
    t.string "name"
    t.boolean "refuse"
    t.integer "standing_id"
    t.string "tax_exemption"
    t.datetime "updated_at", precision: nil
    t.index ["standing_id"], name: "index_clients_on_standing_id"
  end

  create_table "contact_distributers", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "contact_id"
    t.datetime "created_at", precision: nil
    t.string "description"
    t.integer "distributer_id"
    t.datetime "updated_at", precision: nil
    t.index ["contact_id"], name: "index_contact_distributers_on_contact_id"
    t.index ["distributer_id"], name: "index_contact_distributers_on_distributer_id"
  end

  create_table "contact_emails", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "address"
    t.integer "contact_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["contact_id"], name: "index_contact_emails_on_contact_id"
  end

  create_table "contact_phones", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "contact_id"
    t.datetime "created_at", precision: nil
    t.string "number"
    t.string "phone_type"
    t.datetime "updated_at", precision: nil
    t.index ["contact_id"], name: "index_contact_phones_on_contact_id"
  end

  create_table "contacts", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description"
    t.string "fname"
    t.string "lname"
    t.string "mname"
    t.integer "standing_id"
    t.datetime "updated_at", precision: nil
  end

  create_table "distributer_emails", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description"
    t.integer "distributer_id"
    t.string "email"
    t.datetime "updated_at", precision: nil
  end

  create_table "distributer_phones", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description"
    t.integer "distributer_id"
    t.string "number"
    t.datetime "updated_at", precision: nil
    t.index ["distributer_id"], name: "index_distributer_phones_on_distributer_id"
  end

  create_table "distributer_products", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "current_cost"
    t.string "dist_item_number"
    t.integer "distributer_id"
    t.integer "product_id"
    t.datetime "updated_at", precision: nil
    t.index ["distributer_id"], name: "index_distributer_products_on_distributer_id"
    t.index ["product_id"], name: "index_distributer_products_on_product_id"
  end

  create_table "distributers", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.date "date_disabled"
    t.date "date_enabled"
    t.string "min_purchase"
    t.string "min_purchase_freq"
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "employee_permissions", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "employee_id"
    t.integer "permission_id"
    t.datetime "updated_at", precision: nil
    t.index ["employee_id"], name: "index_employee_permissions_on_employee_id"
    t.index ["permission_id"], name: "index_employee_permissions_on_permission_id"
  end

  create_table "employees", charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "contact_id"
    t.datetime "created_at", precision: nil
    t.date "date_hired"
    t.integer "ou_id"
    t.string "password_digest"
    t.string "position"
    t.datetime "updated_at", precision: nil
    t.string "user_name"
    t.index ["contact_id"], name: "index_employees_on_contact_id"
    t.index ["ou_id"], name: "index_employees_on_ou_id"
    t.index ["user_name"], name: "index_employees_on_user_name"
  end

  create_table "expense_payments", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "amount"
    t.datetime "created_at", precision: nil
    t.date "date_payed"
    t.integer "expense_id"
    t.string "identifier"
    t.integer "ou_payment_type_id"
    t.datetime "updated_at", precision: nil
    t.index ["expense_id"], name: "index_expense_payments_on_expense_id"
    t.index ["ou_payment_type_id"], name: "index_expense_payments_on_ou_payment_type_id"
  end

  create_table "expense_types", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description"
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "expenses", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "cost"
    t.datetime "created_at", precision: nil
    t.date "date_incurred"
    t.text "description"
    t.integer "employee_id"
    t.integer "expense_type_id"
    t.string "invoice_number"
    t.string "name"
    t.integer "ou_id"
    t.boolean "paid"
    t.datetime "updated_at", precision: nil
    t.index ["employee_id"], name: "index_expenses_on_employee_id"
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id"
    t.index ["ou_id"], name: "index_expenses_on_ou_id"
  end

  create_table "logs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "ack_at"
    t.text "category"
    t.text "command"
    t.datetime "created_at", null: false
    t.text "details"
    t.bigint "employee_id"
    t.datetime "event_at"
    t.string "in_method"
    t.datetime "issued_at"
    t.string "module_name"
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_logs_on_employee_id"
  end

  create_table "ou_addresses", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.integer "address_id"
    t.datetime "created_at", precision: nil
    t.boolean "delivery"
    t.boolean "invoice"
    t.integer "ou_id"
    t.datetime "updated_at", precision: nil
  end

  create_table "ou_emails", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", precision: nil
    t.string "description"
    t.integer "ou_id"
    t.datetime "updated_at", precision: nil
    t.index ["ou_id"], name: "index_ou_emails_on_ou_id"
  end

  create_table "ou_payment_types", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.date "date_enabled"
    t.date "date_retired"
    t.text "info"
    t.string "method"
    t.string "name"
    t.integer "ou_id"
    t.datetime "updated_at", precision: nil
    t.index ["ou_id"], name: "index_ou_payment_types_on_ou_id"
  end

  create_table "ou_phones", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description"
    t.string "number"
    t.integer "ou_id"
    t.datetime "updated_at", precision: nil
  end

  create_table "ous", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "description"
    t.datetime "disabled_on"
    t.string "name"
    t.integer "root_id"
    t.integer "tax_id"
    t.datetime "updated_at", precision: nil
    t.index ["tax_id"], name: "index_ous_on_tax_id"
  end

  create_table "permissions", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.boolean "admin"
    t.boolean "create_record"
    t.datetime "created_at", precision: nil
    t.boolean "delete_record"
    t.string "name"
    t.string "object_name"
    t.boolean "read_record"
    t.datetime "updated_at", precision: nil
    t.boolean "write_record"
    t.index ["name"], name: "index_permissions_on_name", unique: true
    t.index ["object_name"], name: "index_permissions_on_object_name"
  end

  create_table "product_notes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "note"
    t.integer "product_id"
    t.string "title"
    t.datetime "updated_at", precision: nil
    t.index ["product_id"], name: "index_product_notes_on_product_id"
  end

  create_table "product_tickets", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "date_sold", precision: nil
    t.string "price"
    t.integer "product_id"
    t.integer "quantity"
    t.integer "ticket_id"
    t.datetime "updated_at", precision: nil
    t.index ["product_id"], name: "index_product_tickets_on_product_id"
    t.index ["ticket_id"], name: "index_product_tickets_on_ticket_id"
  end

  create_table "products", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "base_cost"
    t.string "category"
    t.datetime "created_at", precision: nil
    t.text "description"
    t.string "item_number"
    t.string "manufacturer"
    t.string "name"
    t.string "sku"
    t.datetime "updated_at", precision: nil
  end

  create_table "rates", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.boolean "current"
    t.date "date_implemented"
    t.date "date_retired"
    t.string "rate"
    t.datetime "updated_at", precision: nil
  end

  create_table "shipment_trackings", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "date_shipped", precision: nil
    t.integer "item_count"
    t.integer "ticket_id"
    t.string "tracking_number"
    t.datetime "updated_at", precision: nil
    t.index ["ticket_id"], name: "index_shipment_trackings_on_ticket_id"
  end

  create_table "standings", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "taxes", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "date_enabled", precision: nil
    t.datetime "date_retired", precision: nil
    t.string "name"
    t.decimal "rate", precision: 16, scale: 6
    t.string "region"
    t.datetime "updated_at", precision: nil
  end

  create_table "ticket_action_statuses", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "status"
    t.datetime "updated_at", precision: nil
  end

  create_table "ticket_actions", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.string "action"
    t.integer "action_status_id"
    t.datetime "created_at", precision: nil
    t.datetime "date_taken", precision: nil
    t.integer "employee_id"
    t.integer "ticket_id"
    t.datetime "updated_at", precision: nil
    t.index ["action_status_id"], name: "index_ticket_actions_on_action_status_id"
    t.index ["employee_id"], name: "index_ticket_actions_on_employee_id"
    t.index ["ticket_id"], name: "index_ticket_actions_on_ticket_id"
  end

  create_table "ticket_expenses", charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.decimal "cost", precision: 16, scale: 2
    t.datetime "created_at", precision: nil, null: false
    t.datetime "date_incurred", precision: nil
    t.bigint "employee_id"
    t.integer "expense_type_id"
    t.string "note"
    t.integer "ticket_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_ticket_expenses_on_employee_id"
    t.index ["expense_type_id"], name: "index_ticket_expenses_on_expense_type_id"
    t.index ["ticket_id"], name: "index_ticket_expenses_on_ticket_id"
  end

  create_table "ticket_infos", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "employee_id"
    t.text "info"
    t.integer "ticket_id"
    t.datetime "updated_at", precision: nil
    t.index ["employee_id"], name: "index_ticket_infos_on_employee_id"
    t.index ["ticket_id"], name: "index_ticket_infos_on_ticket_id"
  end

  create_table "ticket_notes", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "subject"
    t.integer "ticket_id", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_notes_on_ticket_id"
  end

  create_table "ticket_payments", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.date "date_received"
    t.string "payment"
    t.integer "ticket_id"
    t.datetime "updated_at", precision: nil
    t.index ["ticket_id"], name: "index_ticket_payments_on_ticket_id"
  end

  create_table "ticket_pictures", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.text "note"
    t.datetime "taken_at"
    t.integer "ticket_id", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_pictures_on_ticket_id"
  end

  create_table "ticket_statuses", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  create_table "ticket_times", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.date "date"
    t.string "hours"
    t.integer "ticket_id"
    t.time "time_end"
    t.time "time_start"
    t.datetime "updated_at", precision: nil
    t.index ["ticket_id"], name: "index_ticket_times_on_ticket_id"
  end

  create_table "ticket_work_types", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.integer "ticket_id"
    t.datetime "updated_at", precision: nil
    t.integer "work_type_id"
    t.index ["ticket_id"], name: "index_ticket_work_types_on_ticket_id"
    t.index ["work_type_id"], name: "index_ticket_work_types_on_work_type_id"
  end

  create_table "tickets", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.boolean "billing_fixed"
    t.string "billing_fixed_value"
    t.boolean "billing_hourly"
    t.integer "client_id"
    t.integer "contact_id"
    t.string "cost_parts"
    t.datetime "created_at", precision: nil
    t.datetime "date_created", precision: nil
    t.datetime "date_resolved", precision: nil
    t.integer "default_delivery_id"
    t.integer "default_invoice_id"
    t.integer "employee_id"
    t.string "field_location"
    t.datetime "invoice_date", precision: nil
    t.integer "ou_address_id"
    t.integer "ou_id"
    t.boolean "payed_in_full"
    t.boolean "payment_received"
    t.boolean "payment_requested"
    t.integer "rate_id"
    t.string "sale_cost"
    t.string "short_description"
    t.string "tax"
    t.string "tax_exemption"
    t.integer "tax_id"
    t.decimal "tax_rate", precision: 16, scale: 6
    t.boolean "taxable"
    t.boolean "taxable_labor"
    t.integer "ticket_status_id"
    t.datetime "updated_at", precision: nil
    t.index ["client_id"], name: "index_tickets_on_client_id"
    t.index ["contact_id"], name: "index_tickets_on_contact_id"
    t.index ["employee_id"], name: "index_tickets_on_employee_id"
    t.index ["ou_id"], name: "index_tickets_on_ou_id"
    t.index ["rate_id"], name: "index_tickets_on_rate_id"
    t.index ["tax_id"], name: "index_tickets_on_tax_id"
    t.index ["ticket_status_id"], name: "index_tickets_on_ticket_status_id"
  end

  create_table "work_types", id: :integer, charset: "utf8mb3", collation: "utf8mb3_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name"
    t.datetime "updated_at", precision: nil
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "authenticity_tokens", "employees"
  add_foreign_key "logs", "employees"
  add_foreign_key "ticket_expenses", "employees"
  add_foreign_key "ticket_expenses", "expense_types"
  add_foreign_key "ticket_expenses", "tickets"
  add_foreign_key "ticket_notes", "tickets"
  add_foreign_key "ticket_pictures", "tickets"
  add_foreign_key "tickets", "taxes"
end
