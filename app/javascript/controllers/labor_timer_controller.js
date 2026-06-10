import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    ticketId: Number,
    runningId: { type: Number, default: 0 },
    resumableId: { type: Number, default: 0 },
    startedAt: { type: String, default: "" }
  }
  static targets = ["display", "startBtn", "stopBtn"]

  connect() {
    if (this.runningIdValue > 0 && this.startedAtValue) {
      this.resumeTimer(new Date(this.startedAtValue))
    }
  }

  disconnect() {
    this.clearTimer()
  }

  toggle(event) {
    if (event.target.closest('a')) return
    if (this.runningIdValue > 0) {
      this.stop()
    } else if (this.resumableIdValue > 0) {
      this.resume()
    } else {
      this.start()
    }
  }

  resume() {
    this.applyRunningStyle()
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    fetch(`/tickets/${this.ticketIdValue}/ticket_times/${this.resumableIdValue}/resume`, {
      method: "PATCH",
      headers: { "X-CSRF-Token": csrfToken, "Accept": "application/json" }
    })
      .then(r => r.json())
      .then(data => {
        if (data.response === "failure") { alert(data.error); return }
        this.runningIdValue = data.id
        this.startedAtValue = data.timer_started_at
        this.resumeTimer(new Date(data.timer_started_at))
      })
  }

  start() {
    this.applyRunningStyle()
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    fetch(`/tickets/${this.ticketIdValue}/ticket_times/start`, {
      method: "POST",
      headers: { "X-CSRF-Token": csrfToken, "Accept": "application/json" }
    })
      .then(r => {
        if (r.status === 409) { window.location.reload(); return null }
        return r.json()
      })
      .then(data => {
        if (!data) return
        if (data.response === "failure") { alert(data.error); return }
        this.runningIdValue = data.id
        this.startedAtValue = data.timer_started_at
        this.resumeTimer(new Date(data.timer_started_at))
      })
  }

  applyRunningStyle() {
    this.element.style.backgroundColor = "#c8dcc8"
    const footer = this.element.querySelector(".card-footer")
    if (footer) {
      footer.style.backgroundColor = "#b8ceb8"
      footer.style.borderTopColor = "#a8bea8"
    }
  }

  resumeEntry(event) {
    this.resumableIdValue = parseInt(event.currentTarget.dataset.resumeId)
    this.resume()
  }

  stop() {
    if (!this.runningIdValue) return
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content
    fetch(`/tickets/${this.ticketIdValue}/ticket_times/${this.runningIdValue}/stop`, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": csrfToken,
        "Accept": "application/json"
      }
    })
      .then(() => {
        this.clearTimer()
        window.location.reload()
      })
  }

  resumeTimer(startTime) {
    this.startTime = startTime
    this.startBtnTargets.forEach(btn => btn.classList.add("d-none"))
    if (this.hasStopBtnTarget) this.stopBtnTarget.classList.remove("d-none")
    if (this.hasDisplayTarget) this.displayTarget.classList.remove("d-none")
    this.tick()
    this.interval = setInterval(() => this.tick(), 1000)
  }

  tick() {
    const elapsed = Date.now() - this.startTime.getTime()
    const h = Math.floor(elapsed / 3600000)
    const m = Math.floor((elapsed % 3600000) / 60000)
    const s = Math.floor((elapsed % 60000) / 1000)
    const display = [h, m, s].map(n => String(n).padStart(2, "0")).join(":")
    if (this.hasDisplayTarget) this.displayTarget.textContent = display
  }

  clearTimer() {
    if (this.interval) {
      clearInterval(this.interval)
      this.interval = null
    }
  }
}
