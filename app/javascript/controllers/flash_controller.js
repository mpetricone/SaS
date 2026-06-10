import { Controller } from "@hotwired/stimulus"
import { Toast } from "bootstrap"

export default class extends Controller {
  connect() {
    this._toast = new Toast(this.element, { autohide: false, animation: false })
    this._toast.show()
    this._timer = setTimeout(() => this._fadeAndRemove(), 2000)
  }

  close() {
    clearTimeout(this._timer)
    this._fadeAndRemove()
  }

  _fadeAndRemove() {
    this.element.style.transition = 'opacity 1s ease-out'
    this.element.style.opacity = '0'
    this.element.addEventListener('transitionend', () => this.element.remove(), { once: true })
  }

  disconnect() {
    clearTimeout(this._timer)
    this._toast?.dispose()
  }
}
