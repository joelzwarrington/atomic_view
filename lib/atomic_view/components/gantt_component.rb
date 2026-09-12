# frozen_string_literal: true

module AtomicView
  module Components
    # Gantt
    #
    # A resource-scheduling grid -- rows are resources (sites, rooms, staff),
    # columns are a date scale (day/week/month), and each row's bookings
    # render as bars positioned by real date math. Both axes load more data
    # independently via Turbo, no full page reload:
    #
    #   render(GanttComponent.new(
    #     id: "site-schedule",
    #     dates: @dates,                    # Array<Date> currently loaded/visible
    #     next_rows_path: @next_rows_path,  # more sites (down)
    #     next_dates_path: @next_dates_path # more days (right)
    #   )) do |gantt|
    #     @sites.each do |site|
    #       gantt.with_row(id: dom_id(site, :row), label: site.code, sublabel: site.park.name, origin: @origin) do |row|
    #         site.bookings.each do |booking|
    #           row.with_item(starts_on: booking.starts_on, ends_on: booking.ends_on, label: booking.camper_name, origin: @origin, variant: :success, href: booking_path(booking))
    #         end
    #       end
    #     end
    #   end
    #
    # Unlike `TimelineComponent` (a vertical activity feed, unrelated to this
    # component despite the shared "timeline" vocabulary in casual use), a
    # Gantt's date columns must line up across every row -- that's the whole
    # point of the chart. So horizontal pagination here is *grid-wide*: one
    # sentinel loads more days for every row at once, rather than each row
    # scrolling its own independent strip of items. See `RowComponent` and
    # `ItemComponent` for the per-row/per-bar API.
    #
    # == How the grid is laid out
    #
    # There's no CSS Grid and no client-side column bookkeeping. The label
    # column is `sticky left-0`; each row is a flex box of (label, track).
    # Every row's track is `width: 100%` of a `width: max-content` inner
    # wrapper shared with the date header -- so as the header grows (more
    # date cells appended), every row's track grows with it automatically,
    # via ordinary CSS reflow. Bars are positioned with `position: absolute`
    # and inline `left`/`width` in pixels, computed from real dates (see
    # `.offset_px`/`.span_px` below) -- not from column indices, which would
    # require the server or client to track how many columns have loaded so
    # far. This is also why `origin:` exists (below): it's the one thing that
    # *does* need to stay consistent across requests.
    #
    # == `scale:`
    #
    # `:day` (default), `:week`, or `:month` -- what one column represents.
    # `dates:` is always "one `Date` per column" regardless of scale: every
    # day for `:day`, the first day of each week for `:week`, the first of
    # each month for `:month`. Bars still take real `starts_on`/`ends_on`
    # dates and position themselves proportionally *within* a week/month
    # column (e.g. a booking starting mid-month renders partway into that
    # column, not snapped to its edge) -- see `.offset_px`/`.span_px`.
    #
    # == `origin:` and `scale:` have to round-trip through every request
    #
    # `RowComponent` and `ItemComponent` both take `origin:` -- the `Date`
    # that renders at pixel 0 (the leftmost edge of the whole grid, not just
    # the currently-loaded page of dates), and should be the same value as
    # `dates.first` from the very first render. Every bar's position is
    # computed relative to it. Pick it once and pass the *same* value on
    # every request for this grid -- the initial render, every
    # `next_rows_path` response, and every `next_dates_path` response --
    # typically by round-tripping it through the pagination URLs as a param
    # (see the worked example below). Getting this wrong doesn't break any
    # single response in isolation; it just misaligns bars appended later
    # against columns rendered earlier. At `:week`/`:month` scale, `origin`
    # should fall on a column boundary (a week/month start) for the same
    # reason `dates:` entries do.
    #
    # `scale:` has the exact same requirement, for the exact same reason --
    # it's not stored anywhere Turbo knows about; a stream response is just
    # HTML, so whichever scale is "currently showing" only exists because
    # your controller keeps putting the same `scale:` value into every
    # response for as long as the user is looking at that view. If the day/
    # week/month toggle in your UI is a link/form that reloads the page (the
    # simplest option), the new `scale` param naturally becomes the one
    # in-flight value everything downstream reads from; nothing needs to
    # "remember" the old scale once the page has re-rendered in the new one.
    #
    # == Wiring this up with real data (Pagy keyset + Turbo Streams)
    #
    # Rows don't need any special interface -- `with_row`/`with_item` just
    # want plain values (a label, dates, a variant), so mapping from
    # ActiveRecord is nothing more than the block above: call whatever
    # reads naturally off your models. The only real design decision is
    # pagination, and the two axes are different enough to solve
    # differently:
    #
    # *Rows* are a normal, orderable AR relation -- exactly what Pagy's
    # keyset extra is for (see `Pagy::Method`/`pagy(:keyset, ...)`). A
    # worked example, keyset-paginating `Site`, following the same
    # controller shape as an index action anywhere else in the app:
    #
    #   class RentalsController < ApplicationController
    #     def index
    #       @origin = parse_date(params[:origin]) || Date.current.beginning_of_month
    #       @scale = params[:scale]&.to_sym || GanttComponent::DEFAULT_SCALE
    #       @dates = (@origin...(@origin + 30)).to_a
    #       @pagy, @sites = pagy(:keyset, Site.order(:prefix, :name, :id))
    #
    #       respond_to do |format|
    #         format.html
    #         format.turbo_stream # only reached by the row_pagination frame below
    #       end
    #     end
    #   end
    #
    #   # index.html.erb
    #   <%= render(AtomicView::Components::GanttComponent.new(
    #         id: "site-schedule",
    #         dates: @dates,
    #         scale: @scale,
    #         next_rows_path: (@pagy.next && rentals_path(page: @pagy.next, origin: @origin, scale: @scale, format: :turbo_stream)),
    #         next_dates_path: more_dates_path(origin: @origin, scale: @scale, after: @dates.last)
    #       )) do |gantt|
    #     @sites.each { |site| render_site_row(gantt, site, @origin, @scale, @dates) }
    #   end %>
    #
    #   # index.turbo_stream.erb -- reached when the row_pagination frame's
    #   # lazily-loaded `src` fires (see "Loading more rows" below)
    #   <%= turbo_stream.append("site-schedule_rows") do %>
    #     <% @sites.each { |site| render_site_row(gantt, site, @origin, @scale, @dates) } %>
    #   <% end %>
    #   <%= turbo_stream.replace("site-schedule_row_pagination") do %>
    #     <%= tag.turbo_frame(
    #           id: "site-schedule_row_pagination",
    #           src: (@pagy.next && rentals_path(page: @pagy.next, origin: @origin, scale: @scale, format: :turbo_stream)),
    #           loading: :lazy
    #         ) %>
    #   <% end %>
    #
    # `render_site_row` also has to decide *which* bookings to pass to
    # `with_item` -- not every booking a site has, just the ones that fall
    # anywhere within `@dates` (see "New rows outside the currently-loaded
    # date window" below for why):
    #
    #   def render_site_row(gantt, site, origin, scale, dates)
    #     bookings = site.bookings.select { |b| GanttComponent.overlaps_range?(b.starts_on, b.ends_on, dates.first, dates.last) }
    #     gantt.with_row(id: dom_id(site, :row), label: site.code, sublabel: site.park.name, origin: origin, scale: scale) do |row|
    #       bookings.each { |b| row.with_item(starts_on: b.starts_on, ends_on: b.ends_on, label: b.camper_name, origin: origin, scale: scale, variant: :success, href: booking_path(b)) }
    #     end
    #   end
    #
    # *Dates* aren't an AR relation at all -- "the next 30 days" is just date
    # arithmetic, so `next_dates_path` is simpler custom logic rather than
    # Pagy: a `MoreDatesController` (or an action alongside the one above)
    # that takes `after:` (the last date currently loaded), `origin:`, and
    # `scale:`, computes the next batch of `Date`s, and returns a stream
    # that appends both new date header cells *and* any new bars those dates
    # bring into range -- neither one is optional, and this is genuinely two
    # separate append operations, since the header cells and the bars live
    # in different DOM containers (`#{id}_dates` vs. each row's own
    # `track_id`):
    #
    #   class MoreDatesController < ApplicationController
    #     def show
    #       origin = parse_date(params[:origin])
    #       scale = params[:scale].to_sym
    #       after = parse_date(params[:after])
    #       new_dates = next_batch_of_dates(after: after, scale: scale) # your own date-arithmetic helper
    #       @sites = authorized(Site.all).order(:prefix, :name, :id) # the same rows currently on the page -- see below
    #     end
    #   end
    #
    #   # show.turbo_stream.erb
    #   <% new_dates.each do |date| %>
    #     <%= turbo_stream.append("site-schedule_dates") do %>
    #       <%= render(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: date, scale: scale, today: Date.current)) %>
    #     <% end %>
    #   <% end %>
    #
    #   <% @sites.each do |site| %>
    #     <% bookings = site.bookings.select { |b| AtomicView::Components::GanttComponent.overlaps_range?(b.starts_on, b.ends_on, new_dates.first, new_dates.last) } %>
    #     <% bookings.each do |b| %>
    #       <%= turbo_stream.append(dom_id(site, :row) + "_track") do %>
    #         <%= render(AtomicView::Components::GanttComponent::ItemComponent.new(starts_on: b.starts_on, ends_on: b.ends_on, origin: origin, scale: scale, label: b.camper_name, variant: :success, href: booking_path(b))) %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    #   <%= turbo_stream.replace("site-schedule_date_sentinel") do %>
    #     <div id="site-schedule_date_sentinel" data-atomic-view--gantt-target="dateSentinel" data-next-page="<%= more_dates_path(origin: origin, scale: scale, after: new_dates.last) %>"></div>
    #   <% end %>
    #
    # That response needs to know which rows are currently rendered (to
    # backfill *their* new bars, not just draw the header) -- either
    # re-derive the same page of rows from `params[:page]`/keyset params
    # round-tripped alongside `after:`, or (simpler, if the row page is
    # small) have the client send the visible row ids and scope the query to
    # just those. `prev_dates_path`'s response is the same shape with every
    # `append` swapped for `prepend`, targeting `#{id}_date_start_sentinel`
    # instead.
    #
    # == New rows outside the currently-loaded date window
    #
    # A booking's bar always renders at its real, correctly-computed pixel
    # position -- it is never clipped or hidden by this component. So a site
    # loaded later (via `next_rows_path`) whose booking starts on day 90,
    # when only 30 days are loaded, renders that bar 90 columns from
    # `origin` regardless -- past the last date header cell, in the blank
    # area where the track's gridline background stops (that background,
    # like the header, only ever covers `dates`; it doesn't extend to meet
    # an overflowing bar). It isn't lost: the browser's scroll region grows
    # to include it (out-of-flow descendants still count toward their
    # scrolling ancestor's scrollable area), so scrolling right reveals it
    # sitting in that gap, and it "snaps" into a normal, gridded column the
    # moment `next_dates_path` loads that far.
    #
    # That's a legitimate transient state, not a bug -- but there's rarely a
    # reason to let it happen at all. Scope every row's bookings to ones
    # that actually intersect `dates` (see `render_site_row` above,
    # `.overlaps_range?`) before calling `with_item`, the same way you'd
    # already scope any other index view's records to what's on the current
    # page. A booking that starts beyond the loaded window simply isn't
    # rendered yet; it appears exactly when `next_dates_path` reaches it,
    # via that response's own "backfill every row's new bars" step (see
    # "Loading more days" below) -- which is the same step responsible for
    # backfilling it into *this* row once it exists, no special-casing
    # needed for "a row that was loaded after the date window had already
    # moved."
    #
    # == Turbo Stream contract
    #
    # === Loading more rows
    #
    # `next_rows_path` is rendered as a lazily-loaded `<turbo-frame
    # loading="lazy">` (`#{id}_row_pagination`, see `row_pagination_id`) --
    # the same "infinite frame" pattern as any other keyset-paginated index
    # page in a Turbo app: no custom JS, the frame's own `loading="lazy"`
    # fetches `src` once it scrolls into the *page* viewport. That fetch's
    # response is a turbo_stream (the frame's `src` should carry
    # `format: :turbo_stream`, same as the example above) that:
    #   1. `append`s new `RowComponent`s to `#{id}_rows`
    #   2. `replace`s `#{id}_row_pagination` with an updated frame (new
    #      `src`) to continue the chain, or an empty one (no `src`) when
    #      there are no more rows
    #
    # === Loading more days, in either direction
    #
    # `next_dates_path` (scrolling right) and `prev_dates_path` (scrolling
    # left) are each watched by their own sentinel, both handled by a small
    # Stimulus controller (`atomic-view--gantt`) -- unlike the row frame,
    # these sentinels' intersection has to be measured against the grid's
    # own horizontally-scrolling container, not the page viewport, which a
    # plain `loading="lazy"` frame can't do (it only ever watches the page
    # viewport). Fetched the same way, with `Accept:
    # text/vnd.turbo-stream.html`.
    #
    # A `next_dates_path` response must:
    #   1. `append`s new `DateHeaderComponent` cells to `#{id}_dates`
    #   2. for every row *currently on the page*, `append`s any new
    #      `ItemComponent` bars that fall in the newly-loaded date range to
    #      that row's `RowComponent#track_id`
    #   3. `replace`s `#{id}_date_sentinel` with an updated one, or `remove`s
    #      it when there are no more days ahead
    #
    # A `prev_dates_path` response is the mirror image -- `prepend` instead
    # of `append` to `#{id}_dates` and each row's track (bars are absolutely
    # positioned, so prepend vs. append only matters for the date header
    # cells' visual order), and it targets `#{id}_date_start_sentinel`
    # instead. After that stream renders, the controller adds the newly-
    # prepended width to the scroller's `scrollLeft` so the content the user
    # was already looking at doesn't visually jump -- the same scroll-anchor
    # correction any "load older messages above" infinite-scroll UI needs.
    #
    # See "New rows outside the currently-loaded date window" above for what
    # happens when a bar's dates fall outside what `next_dates_path`/
    # `prev_dates_path` have loaded so far -- a real, if usually avoidable,
    # possibility on this axis too (a newly-appended row's bookings, or a
    # newly-appended bar from a horizontal-load response, same idea either
    # way).
    #
    # Rows themselves only paginate forward (down) -- `next_rows_path` has
    # no `prev_rows_path` counterpart. Add one yourself (a second lazily-
    # loaded frame above `#{id}_rows`, prepending instead of appending) if
    # you need it; nothing here assumes rows can't also load backward, there
    # just isn't a use case yet that needs it.
    class GanttComponent < AtomicView::Component
      DEFAULT_CELL_WIDTH = 42
      DEFAULT_LABEL_WIDTH = 176
      DEFAULT_SCALE = :day
      SCALES = %i[day week month].freeze

      # Bar height, the gap below it before the next lane, and the gap above
      # the first lane -- see `ItemComponent#lane`/`RowComponent#lanes` and
      # `.pack_lanes` for the overlap-handling these size.
      BAR_HEIGHT = 28
      LANE_GAP = 8
      LANE_TOP_PADDING = 8
      LANE_HEIGHT = BAR_HEIGHT + LANE_GAP

      renders_many :rows, "AtomicView::Components::GanttComponent::RowComponent"

      attr_reader :id, :dates, :next_rows_path, :next_dates_path, :prev_dates_path, :cell_width, :label_width,
        :scale, :today, :date_root_margin, :empty_message

      # @param id [String] unique DOM id for this grid; every other id
      #   (rows/dates containers, sentinels, frames) is derived from it.
      # @param dates [Array<Date>] the date columns to render *this call* --
      #   for the initial render, the first page of the visible range; a
      #   `next_dates_path`/`prev_dates_path` response renders only the
      #   newly-appended/prepended dates. One entry per column regardless of
      #   `scale` -- see "`scale:`" above.
      # @param next_rows_path [String, nil] URL for the next page of rows,
      #   rendered as a lazily-loaded turbo-frame. Omit (nil) when there are
      #   no more rows to load.
      # @param next_dates_path [String, nil] URL for the next page of date
      #   columns, loaded when the grid scrolls right. Omit when there are no
      #   more days ahead to load.
      # @param prev_dates_path [String, nil] URL for the previous page of
      #   date columns, loaded when the grid scrolls left. Omit when there
      #   are no earlier days to load.
      # @param cell_width [Integer] pixel width of one column. Must match
      #   whatever `RowComponent`/`ItemComponent` instances use for this same
      #   grid (they default to the same constant, so leave this alone unless
      #   you're overriding it everywhere).
      # @param label_width [Integer] pixel width of the sticky label column.
      # @param scale [Symbol] one of #{SCALES.join(", ")} -- what one column
      #   represents. Must match every `RowComponent`/`ItemComponent` in this
      #   grid, same as `cell_width`.
      # @param today [Date, nil] highlights the column `today` falls within.
      # @param date_root_margin [String] IntersectionObserver rootMargin for
      #   the horizontal date sentinels, rooted at the grid's own scroll
      #   container rather than the viewport. Applied as given to the
      #   trailing (right/`next_dates_path`) sentinel and mirrored
      #   left-for-right for the leading (left/`prev_dates_path`) one.
      # @param empty_message [String] shown when there are no rows at all.
      def initialize(
        id:,
        dates:,
        next_rows_path: nil,
        next_dates_path: nil,
        prev_dates_path: nil,
        cell_width: DEFAULT_CELL_WIDTH,
        label_width: DEFAULT_LABEL_WIDTH,
        scale: DEFAULT_SCALE,
        today: nil,
        date_root_margin: "0px 400px 0px 0px",
        empty_message: "Nothing scheduled.",
        **options
      )
        super()
        @id = id
        @dates = dates
        @next_rows_path = next_rows_path
        @next_dates_path = next_dates_path
        @prev_dates_path = prev_dates_path
        @cell_width = cell_width
        @label_width = label_width
        @scale = scale.to_sym
        @today = today
        @date_root_margin = date_root_margin
        @empty_message = empty_message
        @options = options
      end

      # Absolute position of `date`, in column units, for the given `scale`.
      # Epoch-independent (only ever used as a difference between two calls,
      # in `.offset_px`/`.span_px` below) -- fractional for `:week`/`:month`,
      # e.g. a date 3 days into a 7-day week column is `3/7.0` past that
      # column's own whole-number position.
      def self.position(date, scale: DEFAULT_SCALE)
        date = date.to_date
        case scale.to_sym
        when :week
          date.jd / 7.0
        when :month
          (date.year * 12 + date.month) + (date.day - 1).to_f / Date.civil(date.year, date.month, -1).day
        else
          date.jd
        end
      end

      # The first date of the column `date` falls within -- `date` itself
      # for `:day`, the column's week/month start otherwise. Used to snap a
      # single date (e.g. `today`) to its column's left edge, as opposed to
      # `.offset_px`, which places a date at its exact proportional position
      # *within* a column.
      def self.period_start(date, scale: DEFAULT_SCALE)
        date = date.to_date
        case scale.to_sym
        when :week then date.beginning_of_week
        when :month then date.beginning_of_month
        else date
        end
      end

      # Whether `starts_on`..`ends_on` shares any inclusive day with
      # `range_starts_on`..`range_ends_on`. Meant for scoping which bookings
      # to render at all -- e.g. `site.bookings.select { |b|
      # GanttComponent.overlaps_range?(b.starts_on, b.ends_on, dates.first,
      # dates.last) }` before calling `with_item` -- so a row never carries
      # bars far outside what's currently loaded; see "New rows outside the
      # currently-loaded date window" above.
      def self.overlaps_range?(starts_on, ends_on, range_starts_on, range_ends_on)
        starts_on.to_date <= range_ends_on.to_date && ends_on.to_date >= range_starts_on.to_date
      end

      # Pixel offset of `date` from `origin` -- the left edge of a bar/strip
      # starting on `date`. Negative when `date` is before `origin` (a bar
      # that started before the currently-loaded window); callers don't need
      # to clip this themselves, it just renders (partially) off the
      # scroller's left edge.
      def self.offset_px(date, origin:, cell_width: DEFAULT_CELL_WIDTH, scale: DEFAULT_SCALE)
        round_px((position(date, scale: scale) - position(origin, scale: scale)) * cell_width)
      end

      # Pixel width of a bar spanning `starts_on`..`ends_on`, inclusive of
      # both end dates.
      def self.span_px(starts_on, ends_on, cell_width: DEFAULT_CELL_WIDTH, scale: DEFAULT_SCALE)
        round_px((position(ends_on.to_date + 1, scale: scale) - position(starts_on, scale: scale)) * cell_width)
      end

      # Rounds a computed pixel value to 2 decimal places -- enough to erase
      # the floating-point noise `:week`/`:month` math produces (e.g.
      # `30.000000000582077`) without losing meaningful sub-pixel precision
      # -- and drops the decimal entirely when it rounds to a whole number,
      # so `:day`-scale math (already exact integers) keeps rendering plain
      # ("120px", not "120.0px").
      def self.round_px(value)
        rounded = value.round(2)
        (rounded == rounded.to_i) ? rounded.to_i : rounded
      end
      private_class_method :round_px

      # Greedily assigns each `[starts_on, ends_on]` pair in `ranges` to the
      # lowest-numbered lane that doesn't overlap anything already placed
      # there, returning the lanes as an `Array<Integer>` in the same order
      # as `ranges` (not sort order -- `ranges` doesn't need to be
      # pre-sorted). Two ranges "overlap" if they share any inclusive day;
      # adjacent ranges (one ending the day before the next starts) can share
      # a lane. See `ItemComponent#lane`/`RowComponent#lanes` for how to use
      # the result.
      #
      #   GanttComponent.pack_lanes([[Date.new(2026, 9, 1), Date.new(2026, 9, 5)], [Date.new(2026, 9, 3), Date.new(2026, 9, 8)], [Date.new(2026, 9, 10), Date.new(2026, 9, 12)]])
      #   # => [0, 1, 0] -- the first two overlap (Sep 3-5) so need separate lanes;
      #   #    the third starts after the first one ends, so reuses lane 0.
      def self.pack_lanes(ranges)
        lane_ends = []
        lanes = Array.new(ranges.size)

        ranges.each_with_index.sort_by { |(starts_on, _ends_on), _index| starts_on.to_date }.each do |(starts_on, ends_on), index|
          starts_on = starts_on.to_date
          ends_on = ends_on.to_date
          lane = lane_ends.index { |lane_end| starts_on > lane_end } || lane_ends.length
          lane_ends[lane] = ends_on
          lanes[index] = lane
        end

        lanes
      end

      def scroller_id = "#{id}_scroller"
      def dates_id = "#{id}_dates"
      def rows_id = "#{id}_rows"
      def row_pagination_id = "#{id}_row_pagination"
      def date_sentinel_id = "#{id}_date_sentinel"
      def date_loader_id = "#{id}_date_loader"
      def date_start_sentinel_id = "#{id}_date_start_sentinel"
      def date_start_loader_id = "#{id}_date_start_loader"

      def paginated_rows? = next_rows_path.present?
      def paginated_dates_forward? = next_dates_path.present?
      def paginated_dates_backward? = prev_dates_path.present?
      def empty? = rows.empty?

      def html_options
        @options.except(:class, :data)
      end

      def html_class
        class_names("rounded-card border border-border bg-surface", @options[:class])
      end

      def data_attributes
        controllers = ["atomic-view--gantt", @options.dig(:data, :controller)].compact.join(" ")
        (@options[:data] || {}).except(:controller).merge(
          "controller" => controllers,
          "atomic-view--gantt-date-root-margin-value" => date_root_margin
        )
      end
    end
  end
end
