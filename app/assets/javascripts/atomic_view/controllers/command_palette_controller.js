import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "row", "section"]

  highlightedIndex = null

  connect() {
    document.addEventListener("keydown", this.onGlobalKeydown)
    this.element.addEventListener("close", this.onClose)
    this.element.addEventListener("click", this.closeOnBackdrop)
  }

  disconnect() {
    document.removeEventListener("keydown", this.onGlobalKeydown)
    this.element.removeEventListener("close", this.onClose)
    this.element.removeEventListener("click", this.closeOnBackdrop)
  }

  closeOnBackdrop = (event) => {
    if (event.target === this.element) this.element.close()
  }

  onGlobalKeydown = (event) => {
    if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === "k") {
      event.preventDefault()
      this.element.showModal()
    }
  }

  onClose = () => {
    this.inputTarget.value = ""
    this.rowTargets.forEach((row) => row.classList.remove("hidden"))
    this.sectionTargets.forEach((section) => section.classList.remove("hidden"))
    this.clearHighlight()
  }

  filter() {
    const query = this.inputTarget.value.trim().toLowerCase()

    this.rowTargets.forEach((row) => {
      const matches = row.dataset.searchText.includes(query)
      row.classList.toggle("hidden", !matches)
    })

    // Hide a section immediately once every one of its rows is filtered
    // out, rather than leaving its (now empty) label dangling until the
    // server-side Turbo Stream search catches up.
    this.sectionTargets.forEach((section) => {
      const hasVisibleRow = this.rowTargets.some((row) => section.contains(row) && !row.classList.contains("hidden"))
      section.classList.toggle("hidden", !hasVisibleRow)
    })

    this.clearHighlight()
  }

  navigate(event) {
    if (event.key === "ArrowDown") {
      event.preventDefault()
      this.moveHighlight(1)
    } else if (event.key === "ArrowUp") {
      event.preventDefault()
      this.moveHighlight(-1)
    } else if (event.key === "Enter") {
      this.activateHighlighted(event)
    }
  }

  moveHighlight(delta) {
    const visibleRows = this.visibleRows
    if (visibleRows.length === 0) return

    const nextIndex = this.nextIndex(visibleRows.length, delta)
    this.highlight(visibleRows, nextIndex)
  }

  nextIndex(count, delta) {
    if (this.highlightedIndex === null) return delta === 1 ? 0 : count - 1
    return (this.highlightedIndex + delta + count) % count
  }

  highlight(visibleRows, index) {
    visibleRows.forEach((row) => row.classList.remove("bg-offset"))

    this.highlightedIndex = index
    const row = visibleRows[index]
    if (!row) return

    row.classList.add("bg-offset")
    row.scrollIntoView({ block: "nearest" })
  }

  activateHighlighted(event) {
    if (this.highlightedIndex === null) return

    const row = this.visibleRows[this.highlightedIndex]
    if (!row) return

    event.preventDefault()
    row.click()
  }

  clearHighlight() {
    this.rowTargets.forEach((row) => row.classList.remove("bg-offset"))
    this.highlightedIndex = null
  }

  get visibleRows() {
    return this.rowTargets.filter((row) => !row.classList.contains("hidden"))
  }
}
