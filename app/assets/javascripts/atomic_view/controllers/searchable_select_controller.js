import { Controller } from "@hotwired/stimulus"

// Progressively enhances a real, hidden <select> (see the `searchable`
// concern in select_component.rb/collection_select_component.rb) into a
// trigger + search + list combobox. Reads the select's own <option>
// elements to build the list -- there's no separate Ruby-side data source
// to duplicate or keep in sync with `selected`/`include_blank`/etc.
// Picking an item writes back into the real select's value and dispatches
// a bubbling `change`, so it participates in a real form submission (e.g.
// FiltersComponent's form-level auto-submit) exactly like a plain select.
//
// Paired with `atomic-view--dropdown` on the same element for open/close,
// positioning, and outside-click/Esc handling -- this controller only
// owns the list content and the select/label sync.
export default class extends Controller {
  static targets = ["select", "input", "label", "list"]

  connect() {
    this.buildList()
    this.syncLabel()
    this.selectTarget.addEventListener("change", this.syncLabel)
  }

  disconnect() {
    this.selectTarget.removeEventListener("change", this.syncLabel)
  }

  buildList() {
    this.listTarget.innerHTML = ""

    Array.from(this.selectTarget.options).forEach((option) => {
      const button = document.createElement("button")
      button.type = "button"
      button.textContent = option.text
      button.dataset.searchText = option.text.toLowerCase()
      button.className = "flex w-full items-center gap-2.5 rounded-well px-2 py-2 text-sm text-foreground hover:bg-offset"
      button.addEventListener("click", () => this.choose(option))
      this.listTarget.appendChild(button)
    })
  }

  choose(option) {
    this.selectTarget.value = option.value
    this.selectTarget.dispatchEvent(new Event("change", {bubbles: true}))
    this.syncLabel()
    this.dropdownController?.close()
  }

  filter() {
    const query = this.inputTarget.value.trim().toLowerCase()

    this.listTarget.querySelectorAll("button").forEach((button) => {
      button.classList.toggle("hidden", !button.dataset.searchText.includes(query))
    })
  }

  syncLabel = () => {
    const selected = this.selectTarget.options[this.selectTarget.selectedIndex]
    this.labelTarget.textContent = selected ? selected.text : ""
  }

  get dropdownController() {
    return this.application.getControllerForElementAndIdentifier(this.element, "atomic-view--dropdown")
  }
}
