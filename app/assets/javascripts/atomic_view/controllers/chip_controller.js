import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove() {
    this.element.classList.add("opacity-0", "transition-opacity")
    setTimeout(() => this.element.remove(), 200)
  }
}
