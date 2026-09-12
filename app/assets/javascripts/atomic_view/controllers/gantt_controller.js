import { Controller } from "@hotwired/stimulus"
// `@hotwired/turbo-rails`'s own module re-exports the real Turbo namespace
// under a *named* `Turbo` export (`export { Turbo }`, itself `* as Turbo
// from "@hotwired/turbo"`) rather than being that namespace directly --
// `import * as Turbo from "@hotwired/turbo-rails"` looks right but actually
// gives back `{ Turbo: {...}, cable: {...} }`, one level too shallow.
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="atomic-view--gantt"
//
// Handles the grid's horizontal (date) pagination:
//
//   - forward (scrolling right, more days ahead): an IntersectionObserver
//     watches a trailing sentinel, rooted at this grid's own `scroller`
//     target rather than the page viewport (a `loading="lazy"` frame only
//     ever watches the page viewport, which is why the row axis --
//     `GanttComponent#row_pagination_id` -- can use one but this can't).
//   - backward (earlier days): a plain button the user clicks --
//     `dateStartTrigger` -- not auto-loaded on scroll. An
//     IntersectionObserver-driven backward sentinel sitting right at the
//     scroll container's start is already within its own rootMargin the
//     instant it's observed, before the user has done anything, and
//     "wait for a gesture first" guards around that both have real gaps
//     (a plain `scroll` listener never fires if the very first gesture
//     *is* trying to scroll left from `scrollLeft: 0`, since the browser
//     doesn't dispatch one when the position can't change; and gating the
//     observer's own callback doesn't work either, since
//     IntersectionObserver only calls back on a *change* in intersection
//     state, so the one notification for an already-in-view target fires
//     and gets dropped while gated, then never re-fires once ungated,
//     since nothing about its geometry changed in between). A real click
//     sidesteps all of that -- see `loadEarlierDates` below.
//
// Both directions share the same fetch/prepend-or-append/rebase mechanics;
// see `GanttComponent`'s class docs for what each direction's stream
// response is expected to contain.
//
// The forward sentinel and the backward trigger both carry their page URL
// as a `data-*` attribute on themselves (rather than a Stimulus Value on
// this controller's root) so a `turbo_stream.replace` of just that element
// is enough to advance the cursor. `dateSentinelTargetConnected` re-observes
// automatically whenever Turbo swaps the forward sentinel out for its
// replacement -- no manual re-wiring needed after each page loads; the
// backward trigger needs no such wiring at all, since its `data-action`
// attribute is enough for Stimulus to bind the click handler to whatever
// element currently has it, including a freshly-swapped-in replacement.
export default class extends Controller {
  static targets = ["scroller", "dates", "dateSentinel", "dateLoader", "dateStartTrigger", "dateStartLoader", "originAnchored"]
  static values = {
    dateRootMargin: { type: String, default: "0px 400px 0px 0px" },
  }

  // Target-connected callbacks (below) can fire for targets already present
  // in the initial DOM *before* `connect()` runs -- Stimulus wires up
  // existing targets as part of connecting the controller itself, and that
  // includes invoking their connected callbacks, ahead of calling
  // `connect()`. So the observer `dateSentinelTargetConnected` reaches for
  // has to exist by `initialize()` (guaranteed to run first, exactly once),
  // not `connect()` -- creating it there worked by coincidence whenever a
  // sentinel was added later via Turbo Stream, and threw on the very first
  // (already-in-the-DOM) sentinel otherwise.
  initialize() {
    this.dateForwardLoading = false
    this.dateBackwardLoading = false
    // Running total of pixel width ever prepended to the date header so far
    // -- see `rebaseOriginAnchored` below.
    this.prependedWidth = 0

    this.dateForwardObserver = new IntersectionObserver(this.handleDateForwardIntersect, {
      root: this.hasScrollerTarget ? this.scrollerTarget : null,
      rootMargin: this.dateRootMarginValue,
      threshold: 0,
    })
  }

  disconnect() {
    this.dateForwardObserver.disconnect()
  }

  dateSentinelTargetConnected(element) {
    this.dateForwardObserver.observe(element)
  }

  dateSentinelTargetDisconnected(element) {
    this.dateForwardObserver.unobserve(element)
  }

  handleDateForwardIntersect = (entries) => {
    for (const entry of entries) {
      if (entry.isIntersecting) this.loadMoreDates(entry.target)
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

  // Bound via `data-action="click->atomic-view--gantt#loadEarlierDates"` on
  // the `dateStartTrigger` button -- see this class's docs for why backward
  // pagination is a click rather than a scroll-triggered sentinel.
  async loadEarlierDates(event) {
    const trigger = event.currentTarget
    const url = trigger.dataset.prevPage
    if (!url || this.dateBackwardLoading) return

    this.dateBackwardLoading = true
    trigger.disabled = true
    this.toggleLoader(this.hasDateStartLoaderTarget ? this.dateStartLoaderTarget : null, true)

    const widthBefore = this.hasDatesTarget ? this.datesTarget.scrollWidth : 0
    const anchoredBeforeRender = new Set(this.originAnchoredTargets)

    try {
      await this.renderStream(url, "earlier date columns")

      // The prepended cells pushed everything else to the right by however
      // much width they added -- without this, the user's viewport would
      // stay anchored to the same *scroll offset*, which now points at
      // different (newly-loaded) content instead of what they were just
      // looking at.
      if (this.hasDatesTarget && this.hasScrollerTarget) {
        const addedWidth = this.datesTarget.scrollWidth - widthBefore
        if (addedWidth > 0) {
          this.scrollerTarget.scrollLeft += addedWidth
          this.rebaseOriginAnchored(anchoredBeforeRender, addedWidth)
        }
      }
    } finally {
      this.dateBackwardLoading = false
      // `trigger` may have just been replaced by the stream response (a new
      // page's worth of `data-prev-page`) -- re-read the current element
      // via the target rather than re-enabling the stale reference.
      if (this.hasDateStartTriggerTarget) this.dateStartTriggerTarget.disabled = false
      this.toggleLoader(this.hasDateStartLoaderTarget ? this.dateStartLoaderTarget : null, false)
    }
  }

  // Prepending date-header cells shifts the header's own flow-based
  // coordinate system right by `addedWidth` -- see `GanttComponent`'s class
  // docs, "How the grid is laid out" -- without moving anything positioned
  // in pixels from a fixed `origin:` instead (item bars, the today strip;
  // anything carrying `data-atomic-view--gantt-target="originAnchored"`).
  // Elements already on the page before this response need nudging right by
  // that same `addedWidth` to stay under the header cell they belong to.
  // Ones this response just backfilled (new bars for the newly-loaded date
  // range) were positioned by the server against the *original* origin with
  // no knowledge of drift accumulated by earlier backward loads on this
  // page, so they need the full running total instead.
  //
  // NOTE: this only rebases bars/the today strip backfilled by *this* date
  // axis. A row loaded afterward via `next_rows_path`, or a bar backfilled
  // by a *forward* `next_dates_path` response, is rendered fresh from the
  // same unshifted origin math and would need this same treatment to stay
  // aligned once `prependedWidth` is nonzero -- not wired up, since neither
  // path currently has a hook to apply it from.
  rebaseOriginAnchored(anchoredBeforeRender, addedWidth) {
    for (const el of this.originAnchoredTargets) {
      const delta = anchoredBeforeRender.has(el) ? addedWidth : this.prependedWidth + addedWidth
      const left = Number.parseFloat(el.style.left) || 0
      el.style.left = `${left + delta}px`
    }
    this.prependedWidth += addedWidth
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
}
