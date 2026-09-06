import { Controller } from "@hotwired/stimulus"
import { computePosition, offset, flip, shift, autoUpdate } from "@floating-ui/dom"

export default class extends Controller {
  static targets = ["trigger", "menu"]

  toggle() {
    this.menuTarget.classList.contains("hidden") ? this.open() : this.close()
  }

  open() {
    this.menuTarget.classList.remove("hidden")
    this.cleanup = autoUpdate(this.triggerTarget, this.menuTarget, () => {
      computePosition(this.triggerTarget, this.menuTarget, {
        middleware: [offset(4), flip(), shift({ padding: 8 })]
      }).then(({ x, y }) => {
        Object.assign(this.menuTarget.style, { left: `${x}px`, top: `${y}px` })
      })
    })
    document.addEventListener("click", this.onOutsideClick)
    document.addEventListener("keydown", this.onKeydown)
  }

  close() {
    this.menuTarget.classList.add("hidden")
    if (this.cleanup) this.cleanup()
    document.removeEventListener("click", this.onOutsideClick)
    document.removeEventListener("keydown", this.onKeydown)
  }

  onOutsideClick = (event) => {
    if (!this.element.contains(event.target)) this.close()
  }

  onKeydown = (event) => {
    if (event.key === "Escape") this.close()
  }

  disconnect() {
    this.close()
  }
}
