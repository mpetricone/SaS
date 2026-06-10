window.$ = require("jquery")
require("@rails/ujs").start()
require("@rails/activestorage").start()
import "@popperjs/core"
import "@hotwired/turbo-rails"
import  "@fortawesome/fontawesome-free/js/all.js"
import * as bootstrap from "bootstrap"
import "@rails/activestorage"
ActiveStorage.start()
import './search.js'
import './client_contacts.js'
import './contact_distributer.js'
import './search_hooks.js'
import './alerts.js'
import './itable.js'
import './home.js'
import "./controllers"

document.addEventListener('turbo:load', () => {
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach(el => new bootstrap.Tooltip(el))
})