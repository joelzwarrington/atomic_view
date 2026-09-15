import { Controller } from "@hotwired/stimulus"
import { computePosition, offset, flip, shift, autoUpdate } from "@floating-ui/dom"

export default class extends Controller {
  static targets = ["trigger", "content"]
  static values = { placement: { type: String, default: "top" } }

  show() {
    this.contentTarget.classList.remove("hidden")
    this.cleanup = autoUpdate(this.triggerTarget, this.contentTarget, () => {
      computePosition(this.triggerTarget, this.contentTarget, {
        strategy: "fixed",
        placement: this.placementValue,
        middleware: [offset(8), flip(), shift({ padding: 8 })]
      }).then(({ x, y }) => {
        Object.assign(this.contentTarget.style, { left: `${x}px`, top: `${y}px` })
      })
    })
    document.addEventListener("keydown", this.onKeydown)
  }

  hide() {
    this.contentTarget.classList.add("hidden")
    if (this.cleanup) this.cleanup()
    document.removeEventListener("keydown", this.onKeydown)
  }

  onKeydown = (event) => {
    if (event.key === "Escape") this.hide()
  }

  disconnect() {
    this.hide()
  }
}
