import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { open: Boolean }

  connect() {
    this.element.addEventListener("click", this.closeOnBackdrop)
    if (this.openValue) this.open()
  }

  disconnect() {
    this.element.removeEventListener("click", this.closeOnBackdrop)
  }

  open() {
    this.element.showModal()
  }

  close() {
    this.element.close()
  }

  closeOnBackdrop = (event) => {
    if (event.target === this.element) this.close()
  }
}
