import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { autoDismissMs: Number }

  connect() {
    if (this.autoDismissMsValue > 0) {
      this.timeout = setTimeout(() => this.dismiss(), this.autoDismissMsValue)
    }
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.classList.add("opacity-0", "transition-opacity")
    setTimeout(() => this.element.remove(), 200)
  }
}
