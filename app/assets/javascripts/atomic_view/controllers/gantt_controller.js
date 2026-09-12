import { Controller } from "@hotwired/stimulus"
// `@hotwired/turbo-rails`'s own module re-exports the real Turbo namespace
// under a *named* `Turbo` export (`export { Turbo }`, itself `* as Turbo
// from "@hotwired/turbo"`) rather than being that namespace directly --
// `import * as Turbo from "@hotwired/turbo-rails"` looks right but actually
// gives back `{ Turbo: {...}, cable: {...} }`, one level too shallow.
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="atomic-view--gantt"
//
// Handles the grid's horizontal (date) pagination in both directions --
// vertical (row) pagination needs no controller at all, it's a plain
// `<turbo-frame loading="lazy">` (see `GanttComponent#row_pagination_id`).
// Two IntersectionObservers, both rooted at this grid's own `scroller`
// target rather than the page viewport (a `loading="lazy"` frame only ever
// watches the page viewport, which is why the row axis can use one but this
// one can't):
//
//   - the trailing (date) sentinel loads more days as the grid scrolls
//     right, appending to the end.
//   - the leading (dateStart) sentinel loads earlier days as the grid
//     scrolls left, prepending to the start -- after which this controller
//     nudges `scrollLeft` by however much width was just added, so the
//     content the user was already looking at doesn't visually jump. This
//     is the only asymmetry between the two directions; the fetch/render
//     logic itself is identical.
//
// See `GanttComponent`'s class docs for what each direction's stream
// response is expected to contain.
//
// Sentinels carry their next/prev-page URL as a `data-*` attribute on
// themselves (rather than a Stimulus Value on this controller's root) so a
// turbo_stream.replace of just the sentinel is enough to advance the
// cursor. The `*SentinelTargetConnected` lifecycle callbacks below
// re-observe automatically whenever Turbo swaps a sentinel out for its
// replacement -- no manual re-wiring needed after each page loads.
export default class extends Controller {
  static targets = ["scroller", "dates", "dateSentinel", "dateLoader", "dateStartSentinel", "dateStartLoader"]
  static values = {
    dateRootMargin: { type: String, default: "0px 400px 0px 0px" },
  }

  // Target-connected callbacks (below) can fire for targets already present
  // in the initial DOM *before* `connect()` runs -- Stimulus wires up
  // existing targets as part of connecting the controller itself, and that
  // includes invoking their connected callbacks, ahead of calling
  // `connect()`. So the observers those callbacks reach for have to exist
  // by `initialize()` (guaranteed to run first, exactly once), not
  // `connect()` -- creating them there worked by coincidence whenever a
  // sentinel was added later via Turbo Stream, and threw on the very first
  // (already-in-the-DOM) sentinel otherwise.
  initialize() {
    this.dateForwardLoading = false
    this.dateBackwardLoading = false

    const root = this.hasScrollerTarget ? this.scrollerTarget : null

    this.dateForwardObserver = new IntersectionObserver(this.handleDateForwardIntersect, {
      root,
      rootMargin: this.dateRootMarginValue,
      threshold: 0,
    })

    this.dateBackwardObserver = new IntersectionObserver(this.handleDateBackwardIntersect, {
      root,
      rootMargin: this.mirrorRootMargin(this.dateRootMarginValue),
      threshold: 0,
    })
  }

  disconnect() {
    this.dateForwardObserver.disconnect()
    this.dateBackwardObserver.disconnect()
  }

  dateSentinelTargetConnected(element) {
    this.dateForwardObserver.observe(element)
  }

  dateSentinelTargetDisconnected(element) {
    this.dateForwardObserver.unobserve(element)
  }

  dateStartSentinelTargetConnected(element) {
    this.dateBackwardObserver.observe(element)
  }

  dateStartSentinelTargetDisconnected(element) {
    this.dateBackwardObserver.unobserve(element)
  }

  handleDateForwardIntersect = (entries) => {
    for (const entry of entries) {
      if (entry.isIntersecting) this.loadMoreDates(entry.target)
    }
  }

  handleDateBackwardIntersect = (entries) => {
    for (const entry of entries) {
      if (entry.isIntersecting) this.loadEarlierDates(entry.target)
    }
  }

  async loadMoreDates(sentinel) {
    const url = sentinel.dataset.nextPage
    if (!url || this.dateForwardLoading) return

    this.dateForwardLoading = true
    this.toggleLoader(this.hasDateLoaderTarget ? this.dateLoaderTarget : null, true)

    try {
      await this.renderStream(url, "date columns")
    } finally {
      this.dateForwardLoading = false
      this.toggleLoader(this.hasDateLoaderTarget ? this.dateLoaderTarget : null, false)
    }
  }

  async loadEarlierDates(sentinel) {
    const url = sentinel.dataset.prevPage
    if (!url || this.dateBackwardLoading) return

    this.dateBackwardLoading = true
    this.toggleLoader(this.hasDateStartLoaderTarget ? this.dateStartLoaderTarget : null, true)

    const widthBefore = this.hasDatesTarget ? this.datesTarget.scrollWidth : 0

    try {
      await this.renderStream(url, "earlier date columns")

      // The prepended cells pushed everything else to the right by however
      // much width they added -- without this, the user's viewport would
      // stay anchored to the same *scroll offset*, which now points at
      // different (newly-loaded) content instead of what they were just
      // looking at.
      if (this.hasDatesTarget && this.hasScrollerTarget) {
        const addedWidth = this.datesTarget.scrollWidth - widthBefore
        if (addedWidth > 0) this.scrollerTarget.scrollLeft += addedWidth
      }
    } finally {
      this.dateBackwardLoading = false
      this.toggleLoader(this.hasDateStartLoaderTarget ? this.dateStartLoaderTarget : null, false)
    }
  }

  async renderStream(url, description) {
    this.element.setAttribute("aria-busy", "true")

    try {
      const response = await fetch(url, {
        headers: { Accept: "text/vnd.turbo-stream.html" },
      })

      if (response.ok) {
        Turbo.renderStreamMessage(await response.text())
      } else {
        console.error(`atomic-view--gantt: failed to load more ${description} from ${url} (${response.status})`)
      }
    } catch (error) {
      console.error(`atomic-view--gantt: network error loading more ${description}`, error)
    } finally {
      this.element.removeAttribute("aria-busy")
    }
  }

  toggleLoader(loader, visible) {
    if (loader) loader.hidden = !visible
  }

  // IntersectionObserver rootMargin is "top right bottom left" -- the
  // backward observer needs its margin expanded on the left (where its
  // sentinel sits) instead of the right, everything else the same.
  mirrorRootMargin(margin) {
    const [top, right, bottom, left] = margin.split(/\s+/)
    return `${top} ${left} ${bottom} ${right}`
  }
}
