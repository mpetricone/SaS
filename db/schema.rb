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

ActiveRecord::Schema[8.1].define(version: 2026_05_21_204616) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
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

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "address_clients", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "address_id"
    t.bigint "client_id"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "delivery"
    t.boolean "invoice"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["address_id"], name: "index_address_clients_on_address_id"
    t.index ["client_id"], name: "index_address_clients_on_client_id"
  end

  create_table "address_contacts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "address_id"
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "delivery"
    t.boolean "invoice"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["address_id"], name: "index_address_contacts_on_address_id"
    t.index ["contact_id"], name: "index_address_contacts_on_contact_id"
  end

  create_table "address_distributers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "address_id"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "delivery"
    t.bigint "distributer_id"
    t.boolean "invoice"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["address_id"], name: "index_address_distributers_on_address_id"
    t.index ["distributer_id"], name: "index_address_distributers_on_distributer_id"
  end

  create_table "addresses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "city"
    t.string "country"
    t.datetime "created_at", precision: nil, null: false
    t.string "postal_code"
    t.string "state"
    t.integer "status"
    t.string "street1"
    t.string "street2"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "client_contacts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "receives_quotes", default: false, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_contacts_on_client_id"
    t.index ["contact_id"], name: "index_client_contacts_on_contact_id"
  end

  create_table "client_emails", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "client_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "email"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_emails_on_client_id"
  end

  create_table "client_notes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "client_id"
    t.datetime "created_at", precision: nil, null: false
    t.text "note"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_notes_on_client_id"
  end

  create_table "client_phones", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "client_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "number"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_phones_on_client_id"
  end

  create_table "client_rates", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "client_id"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "current"
    t.date "date_implemented"
    t.date "date_retired"
    t.bigint "rate_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_client_rates_on_client_id"
    t.index ["rate_id"], name: "index_client_rates_on_rate_id"
  end

  create_table "clients", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "default_delivery_id"
    t.integer "default_invoice_id"
    t.string "name"
    t.boolean "refuse"
    t.bigint "standing_id"
    t.string "tax_exemption"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["standing_id"], name: "index_clients_on_standing_id"
  end

  create_table "contact_distributers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.bigint "distributer_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["contact_id"], name: "index_contact_distributers_on_contact_id"
    t.index ["distributer_id"], name: "index_contact_distributers_on_distributer_id"
  end

  create_table "contact_emails", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "address"
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["contact_id"], name: "index_contact_emails_on_contact_id"
  end

  create_table "contact_phones", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.string "number"
    t.string "phone_type"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["contact_id"], name: "index_contact_phones_on_contact_id"
  end

  create_table "contacts", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "fname"
    t.string "lname"
    t.string "mname"
    t.bigint "standing_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["standing_id"], name: "index_contacts_on_standing_id"
  end

  create_table "distributer_emails", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.bigint "distributer_id"
    t.string "email"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["distributer_id"], name: "index_distributer_emails_on_distributer_id"
  end

  create_table "distributer_phones", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.bigint "distributer_id"
    t.string "number"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["distributer_id"], name: "index_distributer_phones_on_distributer_id"
  end

  create_table "distributer_products", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "current_cost"
    t.string "dist_item_number"
    t.bigint "distributer_id"
    t.bigint "product_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["distributer_id"], name: "index_distributer_products_on_distributer_id"
    t.index ["product_id"], name: "index_distributer_products_on_product_id"
  end

  create_table "distributers", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "date_disabled"
    t.date "date_enabled"
    t.string "min_purchase"
    t.string "min_purchase_freq"
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "employee_permissions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "employee_id"
    t.bigint "permission_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_employee_permissions_on_employee_id"
    t.index ["permission_id"], name: "index_employee_permissions_on_permission_id"
  end

  create_table "employees", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "contact_id"
    t.datetime "created_at", precision: nil, null: false
    t.date "date_hired"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.boolean "otp_enabled", default: false, null: false
    t.text "otp_recovery_codes"
    t.text "otp_secret"
    t.bigint "ou_id"
    t.string "password_digest"
    t.string "position"
    t.datetime "updated_at", precision: nil, null: false
    t.string "user_name"
    t.index ["contact_id"], name: "index_employees_on_contact_id"
    t.index ["ou_id"], name: "index_employees_on_ou_id"
    t.index ["user_name"], name: "index_employees_on_user_name"
  end

  create_table "expense_payments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "amount"
    t.datetime "created_at", precision: nil, null: false
    t.date "date_payed"
    t.bigint "expense_id"
    t.string "identifier"
    t.bigint "ou_payment_type_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["expense_id"], name: "index_expense_payments_on_expense_id"
    t.index ["ou_payment_type_id"], name: "index_expense_payments_on_ou_payment_type_id"
  end

  create_table "expense_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "expenses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "cost"
    t.datetime "created_at", precision: nil, null: false
    t.date "date_incurred"
    t.text "description"
    t.bigint "employee_id"
    t.bigint "expense_type_id"
    t.string "invoice_number"
    t.string "name"
    t.bigint "ou_id"
    t.boolean "paid"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_expenses_on_employee_id"
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id"
    t.index ["ou_id"], name: "index_expenses_on_ou_id"
  end

  create_table "logs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
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

  create_table "ou_addresses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "address_id"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "delivery"
    t.boolean "invoice"
    t.bigint "ou_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["address_id"], name: "index_ou_addresses_on_address_id"
    t.index ["ou_id"], name: "index_ou_addresses_on_ou_id"
  end

  create_table "ou_emails", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.bigint "ou_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ou_id"], name: "index_ou_emails_on_ou_id"
  end

  create_table "ou_payment_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "date_enabled"
    t.date "date_retired"
    t.text "info"
    t.string "method"
    t.string "name"
    t.bigint "ou_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ou_id"], name: "index_ou_payment_types_on_ou_id"
  end

  create_table "ou_phones", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "description"
    t.string "number"
    t.bigint "ou_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ou_id"], name: "index_ou_phones_on_ou_id"
  end

  create_table "ous", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.datetime "disabled_on"
    t.string "name"
    t.bigint "root_id"
    t.bigint "tax_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["root_id"], name: "index_ous_on_root_id"
    t.index ["tax_id"], name: "index_ous_on_tax_id"
  end

  create_table "payment_terms", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_payment_terms_on_name", unique: true
    t.index ["position"], name: "index_payment_terms_on_position"
  end

  create_table "permissions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.boolean "admin"
    t.boolean "create_record"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "delete_record"
    t.string "name"
    t.string "object_name"
    t.boolean "read_record"
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "write_record"
    t.index ["name"], name: "index_permissions_on_name", unique: true
    t.index ["object_name"], name: "index_permissions_on_object_name"
  end

  create_table "product_notes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "note"
    t.bigint "product_id"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id"], name: "index_product_notes_on_product_id"
  end

  create_table "product_tickets", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "date_sold", precision: nil
    t.string "price"
    t.bigint "product_id"
    t.integer "quantity"
    t.bigint "ticket_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id"], name: "index_product_tickets_on_product_id"
    t.index ["ticket_id"], name: "index_product_tickets_on_ticket_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "base_cost"
    t.string "category"
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.string "item_number"
    t.string "manufacturer"
    t.string "name"
    t.string "sku"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "quote_labors", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "amount"
    t.integer "billing", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.decimal "estimated_hours", precision: 8, scale: 2
    t.bigint "quote_id", null: false
    t.bigint "rate_id"
    t.datetime "updated_at", null: false
    t.index ["quote_id"], name: "index_quote_labors_on_quote_id"
    t.index ["rate_id"], name: "index_quote_labors_on_rate_id"
  end

  create_table "quote_products", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "price"
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.bigint "quote_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_quote_products_on_product_id"
    t.index ["quote_id"], name: "index_quote_products_on_quote_id"
  end

  create_table "quotes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "accepted_at"
    t.bigint "client_id", null: false
    t.string "code", null: false
    t.datetime "completed_at"
    t.bigint "contact_id"
    t.bigint "converted_ticket_id"
    t.datetime "created_at", null: false
    t.datetime "declined_at"
    t.text "description"
    t.bigint "employee_id"
    t.datetime "expires_at"
    t.bigint "ou_id", null: false
    t.bigint "parent_quote_id"
    t.bigint "payment_term_id"
    t.text "payment_terms_override"
    t.bigint "rate_id"
    t.datetime "sent_at"
    t.integer "status", default: 0, null: false
    t.decimal "tax_rate", precision: 16, scale: 6, default: "0.0"
    t.boolean "taxable", default: false, null: false
    t.boolean "taxable_labor", default: false, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_quotes_on_client_id"
    t.index ["code"], name: "index_quotes_on_code", unique: true
    t.index ["contact_id"], name: "index_quotes_on_contact_id"
    t.index ["converted_ticket_id"], name: "index_quotes_on_converted_ticket_id"
    t.index ["employee_id"], name: "index_quotes_on_employee_id"
    t.index ["expires_at"], name: "index_quotes_on_expires_at"
    t.index ["ou_id"], name: "index_quotes_on_ou_id"
    t.index ["parent_quote_id"], name: "index_quotes_on_parent_quote_id"
    t.index ["payment_term_id"], name: "index_quotes_on_payment_term_id"
    t.index ["rate_id"], name: "index_quotes_on_rate_id"
    t.index ["status"], name: "index_quotes_on_status"
  end

  create_table "rates", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.boolean "current"
    t.date "date_implemented"
    t.date "date_retired"
    t.string "rate"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "employee_id", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["employee_id"], name: "index_sessions_on_employee_id"
  end

  create_table "shipment_trackings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "date_shipped", precision: nil
    t.integer "item_count"
    t.bigint "ticket_id"
    t.string "tracking_number"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ticket_id"], name: "index_shipment_trackings_on_ticket_id"
  end

  create_table "solid_queue_blocked_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_sq_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_sq_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_sq_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_sq_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_sq_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_sq_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_sq_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_sq_jobs_on_class_name"
    t.index ["finished_at"], name: "index_sq_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_sq_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_sq_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_sq_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_sq_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_sq_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_sq_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_sq_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_sq_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_sq_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_sq_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_sq_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_sq_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_sq_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_sq_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_sq_dispatch_all"
  end

  create_table "solid_queue_semaphores", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_sq_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_sq_semaphores_on_key_and_value"
    t.index ["key"], name: "index_sq_semaphores_on_key", unique: true
  end

  create_table "standings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "taxes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "date_enabled", precision: nil
    t.datetime "date_retired", precision: nil
    t.string "name"
    t.decimal "rate", precision: 16, scale: 6
    t.string "region"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ticket_action_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "status"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ticket_actions", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "action"
    t.bigint "action_status_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "date_taken", precision: nil
    t.bigint "employee_id"
    t.bigint "ticket_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["action_status_id"], name: "index_ticket_actions_on_action_status_id"
    t.index ["employee_id"], name: "index_ticket_actions_on_employee_id"
    t.index ["ticket_id"], name: "index_ticket_actions_on_ticket_id"
  end

  create_table "ticket_expenses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.decimal "cost", precision: 16, scale: 2
    t.datetime "created_at", precision: nil, null: false
    t.datetime "date_incurred", precision: nil
    t.bigint "employee_id"
    t.bigint "expense_type_id"
    t.string "note"
    t.bigint "ticket_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_ticket_expenses_on_employee_id"
    t.index ["expense_type_id"], name: "index_ticket_expenses_on_expense_type_id"
    t.index ["ticket_id"], name: "index_ticket_expenses_on_ticket_id"
  end

  create_table "ticket_infos", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "employee_id"
    t.text "info"
    t.bigint "ticket_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_ticket_infos_on_employee_id"
    t.index ["ticket_id"], name: "index_ticket_infos_on_ticket_id"
  end

  create_table "ticket_notes", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "subject"
    t.bigint "ticket_id", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_notes_on_ticket_id"
  end

  create_table "ticket_payments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "date_received"
    t.string "payment"
    t.bigint "ticket_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ticket_id"], name: "index_ticket_payments_on_ticket_id"
  end

  create_table "ticket_pictures", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.text "note"
    t.datetime "taken_at"
    t.bigint "ticket_id", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_pictures_on_ticket_id"
  end

  create_table "ticket_statuses", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ticket_times", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.date "date"
    t.bigint "employee_id"
    t.string "hours"
    t.boolean "running", default: false, null: false
    t.bigint "ticket_id"
    t.time "time_end"
    t.time "time_start"
    t.datetime "timer_started_at"
    t.datetime "timer_stopped_at"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["employee_id"], name: "index_ticket_times_on_employee_id"
    t.index ["running"], name: "index_ticket_times_on_running"
    t.index ["ticket_id"], name: "index_ticket_times_on_ticket_id"
  end

  create_table "ticket_work_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "ticket_id"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "work_type_id"
    t.index ["ticket_id"], name: "index_ticket_work_types_on_ticket_id"
    t.index ["work_type_id"], name: "index_ticket_work_types_on_work_type_id"
  end

  create_table "tickets", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.boolean "billing_fixed"
    t.string "billing_fixed_value"
    t.boolean "billing_hourly"
    t.bigint "client_id"
    t.bigint "contact_id"
    t.string "cost_parts"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "date_created", precision: nil
    t.datetime "date_resolved", precision: nil
    t.integer "default_delivery_id"
    t.integer "default_invoice_id"
    t.bigint "employee_id"
    t.string "field_location"
    t.datetime "invoice_date", precision: nil
    t.integer "ou_address_id"
    t.bigint "ou_id"
    t.boolean "payed_in_full"
    t.boolean "payment_received"
    t.boolean "payment_requested"
    t.bigint "rate_id"
    t.string "sale_cost"
    t.string "short_description"
    t.string "tax"
    t.string "tax_exemption"
    t.bigint "tax_id"
    t.decimal "tax_rate", precision: 16, scale: 6
    t.boolean "taxable"
    t.boolean "taxable_labor"
    t.bigint "ticket_status_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["client_id"], name: "index_tickets_on_client_id"
    t.index ["contact_id"], name: "index_tickets_on_contact_id"
    t.index ["employee_id"], name: "index_tickets_on_employee_id"
    t.index ["ou_id"], name: "index_tickets_on_ou_id"
    t.index ["rate_id"], name: "index_tickets_on_rate_id"
    t.index ["tax_id"], name: "index_tickets_on_tax_id"
    t.index ["ticket_status_id"], name: "index_tickets_on_ticket_status_id"
  end

  create_table "work_types", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "name"
    t.datetime "updated_at", precision: nil, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "logs", "employees"
  add_foreign_key "sessions", "employees"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "ticket_expenses", "employees"
  add_foreign_key "ticket_expenses", "expense_types"
  add_foreign_key "ticket_expenses", "tickets"
  add_foreign_key "ticket_notes", "tickets"
  add_foreign_key "ticket_pictures", "tickets"
  add_foreign_key "tickets", "taxes"
end
