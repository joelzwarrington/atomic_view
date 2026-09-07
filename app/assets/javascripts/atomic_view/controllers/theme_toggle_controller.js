import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "atomic-view-theme"

export default class extends Controller {
  connect() {
    this.apply(this.resolved())
  }

  toggle() {
    this.apply(this.isDark ? "light" : "dark")
  }

  apply(theme) {
    document.documentElement.classList.toggle("dark", theme === "dark")

    try {
      localStorage.setItem(STORAGE_KEY, theme)
    } catch {
      // localStorage unavailable (private browsing, etc.) -- the toggle
      // still works for the current page load, it just won't persist.
    }
  }

  resolved() {
    return this.stored() ?? (this.systemPrefersDark() ? "dark" : "light")
  }

  stored() {
    try {
      const value = localStorage.getItem(STORAGE_KEY)
      return value === "light" || value === "dark" ? value : null
    } catch {
      return null
    }
  }

  systemPrefersDark() {
    return window.matchMedia?.("(prefers-color-scheme: dark)").matches ?? false
  }

  get isDark() {
    return document.documentElement.classList.contains("dark")
  }
}
