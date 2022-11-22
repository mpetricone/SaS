Rails.application.routes.draw do
  get 'expenses/search_by_name' => 'expenses#search_by_name'
  resources :expenses do
    resources :expense_payments
  end

  get 'ou_payment_types/search_by_name' => 'ou_payment_types#search_by_name'
  resources :ou_payment_types

  get 'expense_types/search_by_name' => 'expense_types#search_by_name'
  resources :expense_types

  get 'accounts_receivable' => 'accounts_receivable#index'
  post 'accounts_receivable_search' => 'accounts_receivable#search'

  get 'income_report' => 'income_report#index'
  get 'income_report_report' => 'income_report#report'
  get 'income_report_report3' => 'income_report#report_v3'

  get 'login' => 'sessions#new'
  post 'login' =>  'sessions#create'
  delete 'logout' => 'sessions#destroy'

  post 'billing_ticket_mail/:id' => 'tickets#mail_bill', as: 'billing_ticket_mail'

  patch 'ticket/:id/close_ticket' => 'tickets#close_ticket', as: 'close_ticket'
  patch 'ticket/:id/open_ticket' => 'tickets#open_ticket', as: 'open_ticket'
  get 'tickets/:id/time' => 'tickets#time', as: 'time'
  get 'tickets/index_latest' => 'tickets#index_latest'

  get 'taxes/search_by_name' => 'taxes#search_by_name'
  resources :taxes

  get 'permissions/search_by_name' => 'permissions#search_by_name'
  resources :permissions

  get 'ticket_statuses/search_by_name' => 'ticket_statuses#search_by_name'
  resources :ticket_statuses

  get 'ticket_action_statuses/search_by_name' => 'ticket_action_statuses#search_by_name'
  resources :ticket_action_statuses

  get 'work_types/search_by_name' => 'work_types#search_by_name'
  resources :work_types

  get 'tickets_search_clients' => 'tickets#index_client_list'
  get 'tickets_show_list' => 'tickets#index_show_list'
  get 'ticket_print_view/:id' => 'tickets#print_view', as: 'ticket_print_view'
  get 'ticket_show_tech_info/:id' => 'tickets#show_tech_info', as: 'ticket_show_tech_info'
  resources :tickets do
    resources :product_tickets, except: :edit
    resources :ticket_work_types
    resources :shipment_trackings
    resources :ticket_infos
    resources :ticket_actions
    resources :ticket_times, except: :edit
    resources :ticket_payments
    resources :ticket_expenses
    resources :ticket_pictures
    resources :ticket_notes
  end

  get 'products/search_by_name' => 'products#search_by_name'
  resources :products do
    resources :product_notes
    resources :distributer_products
  end

  get 'distributers/search_by_name' => 'distributers#search_by_name'
  resources :distributers do
    resources :distributer_phones
    resources :distributer_emails
    resources :address_distributers
    resources :contact_distributers
  end

  get 'rates/search_by_name' => 'rates#search_by_name'
  resources :rates

  get 'contacts/search_by_name' => 'contacts#search_by_name'
  resources :contacts do
    resources :contact_phones
    resources :contact_emails
    resources :address_contacts
  end

  get 'clients/search_by_name' => 'clients#search_by_name'
  get 'clients/show2/:id' => 'clients#show2', as: 'clients_show2'
  resources :clients do
    resources :client_phones
    resources :client_emails
    resources :client_contacts
    resources :address_clients
    resources :client_notes
    resources :client_rates
    get 'client_statements' => 'client_statements#index'
    get 'client_statements/generate' => 'client_statements#generate'
  end

  get 'standings/search_by_name' => 'standings#search_by_name'
  resources :standings

  get 'employees/search_by_name' => 'employees#search_by_name'
  resources :employees do
    resources :employee_permissions
  end

  get 'home/index'

  get 'addresses/search_by_name' => 'addresses#search_by_name'
  resources :addresses

  get 'ous/search_by_name' => 'ous#search_by_name'
  resources :ous do
    resources :ou_addresses
    resources :ou_phones
    resources :ou_emails
  end

  #about page
  get 'about/index' => 'about#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

end
