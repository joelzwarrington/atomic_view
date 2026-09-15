import { Controller } from "@hotwired/stimulus"

// Debounced `requestSubmit()` for a filter form -- wired once on the
// `<form>` itself (see FiltersComponent), not per-field, since `input`/
// `change` events from any native form control (a text field, a select, a
// radio -- including a ChipComponent radio dropped into `with_chip`)
// bubble up to the form regardless of where they originate.
export default class extends Controller {
  static values = {delay: {type: Number, default: 150}}

  initialize() {
    this.submit = this.submit.bind(this)
  }

  connect() {
    if (this.delayValue > 0) this.submit = this.debounce(this.submit, this.delayValue)
  }

  submit() {
    this.element.requestSubmit()
  }

  debounce(fn, delay) {
    let timeout
    return (...args) => {
      clearTimeout(timeout)
      timeout = setTimeout(() => fn.apply(this, args), delay)
    }
  }
}
