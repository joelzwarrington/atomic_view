import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  open() {
    this.element.showModal()
  }

  close() {
    this.element.close()
  }

  closeOnBackdrop(event) {
    if (event.target === this.element) this.close()
  }

  connect() {
    this.element.addEventListener("click", this.closeOnBackdrop.bind(this))
  }

  disconnect() {
    this.element.removeEventListener("click", this.closeOnBackdrop.bind(this))
  }
}
