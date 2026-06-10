import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "select"]

  connect() {
    this._originalOptions = Array.from(this.selectTarget.options).map(o => ({
      value: o.value,
      text: o.text
    }))
  }

  filter() {
    const q = this.inputTarget.value.toLowerCase().trim()
    const currentValue = this.selectTarget.value
    this.selectTarget.innerHTML = ""
    this._originalOptions.forEach(o => {
      if (q === "" || o.text.toLowerCase().includes(q)) {
        const opt = document.createElement("option")
        opt.value = o.value
        opt.text = o.text
        if (o.value === currentValue) opt.selected = true
        this.selectTarget.appendChild(opt)
      }
    })
  }
}
