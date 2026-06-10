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

  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]
  resource :account, only: [:show], controller: 'accounts'
  resource :two_factor, only: [:create, :destroy], controller: 'two_factor'
  resource :two_factor_challenge, only: [:new, :create], controller: 'two_factor_challenge'
  get    'login'  => 'sessions#new',     as: :login
  delete 'logout' => 'sessions#destroy', as: :logout

  post 'billing_ticket_mail/:id' => 'tickets#mail_bill', as: 'billing_ticket_mail'

  patch 'ticket/:id/close_ticket' => 'tickets#close_ticket', as: 'close_ticket'
  patch 'ticket/:id/open_ticket' => 'tickets#open_ticket', as: 'open_ticket'
  patch 'ticket/:id/mark_invoice_sent' => 'tickets#mark_invoice_sent', as: 'mark_invoice_sent'
  get 'tickets/:id/time' => 'tickets#time', as: 'time'

  get  'labor_timers'          => 'labor_timers#index',    as: 'labor_timers'
  post 'labor_timers/stop_all' => 'labor_timers#stop_all', as: 'stop_all_labor_timers'
  get 'tickets/index_latest' => 'tickets#index_latest'

  get 'taxes/search_by_name' => 'taxes#search_by_name'
  resources :taxes

  get 'payment_terms/search_by_name' => 'payment_terms#search_by_name'
  resources :payment_terms

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
    resources :ticket_times do
      collection { post :start }
      member     { patch :stop; patch :resume }
    end
    resources :ticket_payments
    resources :ticket_expenses
    resources :ticket_pictures
    resources :ticket_notes
  end

  get 'quotes/search_by_name' => 'quotes#search_by_name'
  resources :quotes do
    resources :quote_products, except: :edit
    resources :quote_labors
    member do
      patch :send_to_client
      patch :accept
      patch :decline
      post  :convert_to_ticket
      post  :add_addendum
      get   :mail_to_client
      post  :mail_to_client_send
      get   :print_view
    end
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
  resources :employees, only: [:index, :new, :edit, :show, :update, :create] do
    resources :employee_permissions
    member { patch :unlock }
  end

  get 'home/index'

  get 'addresses/search_by_name' => 'addresses#search_by_name'
  resources :addresses

  get 'ous/search_by_name' => 'ous#search_by_name'
  #patch 'ou/:id/set_disabled' => 'ous#set_disabled', as: "set_disabled"
  #patch 'ou/:id/clear_disabled' => 'ous#clear_disabled', as: "clear_disabled"
  resources :ous, except: [:destroy] do
    member do
      patch :clear_disabled
      patch :set_disabled
    end
    resources :ou_addresses
    resources :ou_phones
    resources :ou_emails
  end

  patch 'log/:id/ack' => 'logs#ack', as: "ack_log"
  resources :logs, only: [:index, :show]
  #get 'logs' => 'logs#index'
  #get 'logs/:id' => 'logs#show'

  #about page
  get 'about/index' => 'about#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

end
