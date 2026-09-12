# frozen_string_literal: true

module AtomicView
  module Components
    class GanttComponent
      # One "September 2026"-style segment in the `GanttComponent`'s month
      # band strip (see `GanttComponent#month_band_id`), above the
      # day/weekday header row. `#{gantt_id}_month_band` is a single-row CSS
      # Grid sharing the same `grid-auto-columns` as `#{gantt_id}_dates` (see
      # `GanttComponent#column_grid_style`), so a segment carries no pixel
      # width of its own -- just `grid-column: span #{span}`, `span` day-wide
      # tracks stretched together automatically. That also means a segment
      # never needs resizing once rendered: appending/prepending more days
      # elsewhere in the same grid doesn't touch its track sizing, so it's
      # exactly as correct after ten more `prepend`s as it was on the first
      # render.
      #
      # `GanttComponent` renders one of these per distinct month present in
      # `dates:` on the initial render (see `GanttComponent#month_segments`).
      #
      # == Loading more days
      #
      # A `next_dates_path`/`prev_dates_path` Turbo Stream response that
      # `append`s/`prepend`s new `DateHeaderComponent` cells to
      # `#{gantt_id}_dates` (see `GanttComponent`'s class docs) should do the
      # same here, to `#{gantt_id}_month_band`. Simplest when each batch of
      # newly-loaded dates is itself exactly one calendar month (see
      # `RentalsController` in this gem's dummy app for a worked example) --
      # then every response adds exactly one new segment, always with a real
      # label, no chunking needed. A batch that can straddle a month
      # boundary needs to chunk its own dates by month the same way
      # `GanttComponent#month_segments` does, and skip the label (`label:
      # nil`) on whichever chunk continues the month a previous segment
      # already labeled.
      #
      # Order matters the same way it does for date cells: `append` new
      # segments in chronological order; `prepend` them in *reverse*
      # chronological order (latest chunk first), since each prepend pushes
      # the previous one further right.
      class MonthBandComponent < AtomicView::Component
        attr_reader :id, :label, :span

        # @param id [String, nil] DOM id for this segment.
        # @param label [String, nil] the text to show, e.g. `"September 2026"`
        #   -- `nil` renders a blank (unlabeled) segment, for a batch of
        #   newly-loaded dates that continue a month whose label an earlier
        #   segment already shows (see "Loading more days" above).
        # @param span [Integer] how many day columns this segment covers --
        #   becomes `grid-column: span #{span}`.
        def initialize(span:, label: nil, id: nil, **options)
          super()
          @id = id
          @label = label
          @span = span
          @options = options
        end

        def html_options
          @options.except(:class)
        end

        def html_class
          class_names(base_classes, @options[:class])
        end

        def style
          "grid-column: span #{span}"
        end

        private

        def base_classes
          "flex items-center overflow-hidden whitespace-nowrap px-1.5 text-[10px] font-semibold uppercase tracking-wide text-muted-foreground"
        end
      end
    end
  end
end
