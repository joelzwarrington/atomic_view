# frozen_string_literal: true

module AtomicView
  module Components
    class GanttComponent
      # A single resource row within a `GanttComponent` -- a label (e.g. a
      # site code) plus a horizontally-scrolling track that its `ItemComponent`
      # bars position themselves within. Rendered via `GanttComponent#with_row`
      # -- see that class's docs for the full picture, including what
      # `origin:` means and why it has to stay consistent across requests.
      #
      # `track_id` is the id a `next_dates_path`/`prev_dates_path` Turbo
      # Stream response `append`s/`prepend`s new bars to once more date
      # columns load -- this row's own markup doesn't otherwise get
      # re-rendered when that happens.
      class RowComponent < AtomicView::Component
        renders_many :items, "AtomicView::Components::GanttComponent::ItemComponent"

        attr_reader :id, :label, :sublabel, :href, :origin, :cell_width, :label_width, :lanes, :today

        # @param id [String] unique DOM id for this row.
        # @param label [String] primary label (e.g. a site code).
        # @param sublabel [String, nil] secondary label under it (e.g. a park name).
        # @param href [String, nil] wraps the label in a link when given.
        # @param origin [Date] must match the `origin:` given to every
        #   `ItemComponent` in this row (and every other row in this grid) --
        #   used here only for the optional `today:` highlight strip.
        # @param cell_width [Integer] must match the parent `GanttComponent`'s.
        # @param label_width [Integer] must match the parent `GanttComponent`'s.
        # @param lanes [Integer] how many horizontal lanes of overlapping
        #   items this row's track should reserve height for -- `1` (the
        #   default) fits a row with no overlaps. See
        #   `ItemComponent#lane`/`GanttComponent.pack_lanes`.
        # @param today [Date, nil] renders a highlighted strip at this date's
        #   column, when given (typically threaded through from the parent
        #   `GanttComponent#today`).
        def initialize(
          id:,
          label:,
          origin:,
          sublabel: nil,
          href: nil,
          cell_width: GanttComponent::DEFAULT_CELL_WIDTH,
          label_width: GanttComponent::DEFAULT_LABEL_WIDTH,
          lanes: 1,
          today: nil,
          **options
        )
          super()
          @id = id
          @label = label
          @sublabel = sublabel
          @href = href
          @origin = origin
          @cell_width = cell_width
          @label_width = label_width
          @lanes = lanes
          @today = today
          @options = options
        end

        def track_id = "#{id}_track"

        def html_options
          @options.except(:class)
        end

        def html_class
          class_names("flex", @options[:class])
        end

        def track_style
          min_height = GanttComponent::LANE_TOP_PADDING * 2 + (lanes * GanttComponent::LANE_HEIGHT)
          "background-image: repeating-linear-gradient(to right, var(--color-border) 0, var(--color-border) 1px, transparent 1px, transparent #{cell_width}px); min-height: #{min_height}px"
        end

        def today_offset_px
          return nil unless today
          GanttComponent.offset_px(today, origin: origin, cell_width: cell_width)
        end
      end
    end
  end
end
