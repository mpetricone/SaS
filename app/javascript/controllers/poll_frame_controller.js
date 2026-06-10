import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { seconds: { type: Number, default: 5 } }

  connect() {
    this.interval = setInterval(() => this.reload(), this.secondsValue * 1000)
  }

  disconnect() {
    clearInterval(this.interval)
  }

  reload() {
    if (this.element.src) {
      this.element.reload()
    } else {
      this.element.src = window.location.href
    }
  }
}
