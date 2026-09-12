# frozen_string_literal: true

module AtomicView
  module Components
    class GanttComponent
      # A single bar within a `GanttComponent::RowComponent`'s track,
      # positioned by real date math rather than a column index -- see
      # `GanttComponent`'s class docs for why. Rendered via
      # `RowComponent#with_item`, or standalone (e.g. from a
      # `next_dates_path` Turbo Stream response `append`ing a newly-loaded
      # bar into an existing row's `RowComponent#track_id`) since it carries
      # everything it needs -- including `origin:` -- to position itself with
      # no help from its parent row.
      #
      #   row.with_item(starts_on: booking.starts_on, ends_on: booking.ends_on, origin: @origin, label: booking.camper_name, variant: :success)
      #
      #   row.with_item(starts_on: booking.starts_on, ends_on: booking.ends_on, origin: @origin, variant: :outline) do
      #     tag.span("Inquiry", class: "italic")
      #   end
      #
      # `label:` renders as truncated text; pass a block instead for
      # anything richer (an avatar, a badge) -- the block replaces `label:`
      # entirely rather than appending to it.
      #
      # == Updating one bar in place
      #
      # Give it `id:` (e.g. `dom_id(booking, :bar)`) and it becomes a stable
      # Turbo Stream target -- when a booking's status/dates/label change,
      # `turbo_stream.replace(dom_id(booking, :bar), render(...))` swaps just
      # that bar, no different from updating any other DOM-id'd partial. This
      # is a plain, independent update -- no relation to the row/date
      # pagination sentinels elsewhere in this component.
      #
      # == Overlapping bars in the same row
      #
      # Two items with overlapping `starts_on`..`ends_on` ranges need to
      # render in separate horizontal "lanes" so they don't paint on top of
      # each other -- `lane:` (a 0-based integer, default `0`) picks which
      # one. Compute lane assignments for a row's items with
      # `GanttComponent.pack_lanes`, then pass `lanes:` (the count) to the
      # parent `RowComponent#with_row` so its track reserves enough height:
      #
      #   bookings = [overlapping_booking_a, overlapping_booking_b, later_booking]
      #   lanes = AtomicView::Components::GanttComponent.pack_lanes(bookings.map { |b| [b.starts_on, b.ends_on] })
      #
      #   gantt.with_row(id: dom_id(site, :row), label: site.code, origin: @origin, lanes: lanes.max + 1) do |row|
      #     bookings.zip(lanes).each { |booking, lane| row.with_item(starts_on: booking.starts_on, ends_on: booking.ends_on, origin: @origin, lane: lane, label: booking.camper_name) }
      #   end
      #
      # Like `origin:`, a newly-appended bar (from a `next_dates_path`
      # response) needs its `lane:` computed the same way, against every
      # other item already in that row -- and if that pushes the row's lane
      # count higher than what was initially rendered, the response should
      # also `turbo_stream.replace` (or otherwise resize) the row's track to
      # fit, since `RowComponent` only sizes itself once, from the `lanes:`
      # it was given at render time.
      class ItemComponent < AtomicView::Component
        VARIANTS = %i[primary success warning destructive muted outline].freeze

        attr_reader :id, :starts_on, :ends_on, :origin, :cell_width, :scale, :lane, :label, :href, :variant

        # @param id [String, nil] DOM id for this bar. Omit if you never need
        #   to target it directly; give it one (e.g. `dom_id(booking, :bar)`)
        #   to make it a stable Turbo Stream target for later in-place
        #   updates -- see "Updating one bar in place" above.
        # @param starts_on [Date] first day this bar covers.
        # @param ends_on [Date] last day this bar covers (inclusive). Pass
        #   the same value as `starts_on` for a single-day bar. There's no
        #   "open-ended" concept here -- resolve an ongoing booking to a real
        #   end date yourself (e.g. the last date currently loaded) before
        #   calling this.
        # @param origin [Date] must match the `origin:` every other row/item
        #   in this grid uses -- the date that renders at pixel 0.
        # @param cell_width [Integer] must match the parent `GanttComponent`'s.
        # @param scale [Symbol] must match the parent `GanttComponent`'s --
        #   see that class's docs for what it changes about positioning.
        # @param lane [Integer] which horizontal lane (0-based) this bar
        #   renders in, for when it overlaps another item in the same row --
        #   see "Overlapping bars in the same row" above. `0` (the default)
        #   is fine for a row with no overlaps.
        # @param label [String, nil] truncated text label; omit in favor of a
        #   block for richer content.
        # @param href [String, nil] wraps the bar in a link when given --
        #   the whole bar becomes clickable, with a hover/focus treatment to
        #   match.
        # @param variant [Symbol] one of #{VARIANTS.join(", ")} -- maps onto
        #   the gem's existing success/warning/destructive/muted tokens
        #   rather than domain-specific statuses, so map your own status
        #   values onto these however fits.
        def initialize(starts_on:, ends_on:, origin:, id: nil, cell_width: GanttComponent::DEFAULT_CELL_WIDTH, scale: GanttComponent::DEFAULT_SCALE, lane: 0, label: nil, href: nil, variant: :primary, **options)
          super()
          @id = id
          @starts_on = starts_on
          @ends_on = ends_on
          @origin = origin
          @cell_width = cell_width
          @scale = scale.to_sym
          @lane = lane
          @label = label
          @href = href
          @variant = variant.to_sym
          @options = options
        end

        def html_options
          @options.except(:class)
        end

        def position_style
          left = GanttComponent.offset_px(starts_on, origin: origin, cell_width: cell_width, scale: scale)
          width = GanttComponent.span_px(starts_on, ends_on, cell_width: cell_width, scale: scale)
          top = GanttComponent::LANE_TOP_PADDING + (lane * GanttComponent::LANE_HEIGHT)
          "left: #{left}px; width: #{width}px; top: #{top}px; height: #{GanttComponent::BAR_HEIGHT}px"
        end

        def html_class
          class_names(base_classes, href.present? ? interactive_classes : nil, variant_classes, @options[:class])
        end

        def tag_name
          href.present? ? :a : :div
        end

        private

        def base_classes
          "absolute z-[1] flex items-center overflow-hidden rounded-btn px-2.5 text-xs font-semibold whitespace-nowrap"
        end

        def interactive_classes
          "cursor-pointer transition-[filter] hover:brightness-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-surface"
        end

        def variant_classes
          case variant
          when :success
            "bg-success text-success-foreground"
          when :warning
            "bg-warning text-warning-foreground"
          when :destructive
            "bg-destructive text-destructive-foreground line-through opacity-80"
          when :muted
            "bg-muted text-muted-foreground opacity-70"
          when :outline
            "border-2 border-dashed border-muted-foreground/40 bg-transparent text-muted-foreground"
          else
            "bg-primary text-primary-foreground"
          end
        end
      end
    end
  end
end
