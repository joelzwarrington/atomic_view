import { Controller } from "@hotwired/stimulus"

// A key (or chord) bound elsewhere via Stimulus's keyboard event filters,
// e.g. `data-action="keydown.n@window->hotkey#click"`, activates this
// element instead of every shortcut needing its own handler. Ignored while
// the user is typing (an input/textarea/Trix editor has focus) or when the
// element itself isn't interactable right now (hidden, disabled via
// pointer-events: none, ...).
export default class extends Controller {
  click(event) {
    if (this.isClickable && !this.shouldIgnore(event)) {
      event.preventDefault()
      this.element.click()
    }
  }

  focus(event) {
    if (this.isClickable && !this.shouldIgnore(event)) {
      event.preventDefault()
      this.element.focus()
    }
  }

  shouldIgnore(event) {
    const target = event.target
    return event.defaultPrevented || !!target?.closest("input, textarea, trix-editor, [contenteditable]")
  }

  get isClickable() {
    return getComputedStyle(this.element).pointerEvents !== "none"
  }
}
