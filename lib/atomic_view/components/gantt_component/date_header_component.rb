# frozen_string_literal: true

module AtomicView
  module Components
    class GanttComponent
      # A single day column header cell within a `GanttComponent`'s
      # `#{id}_dates` grid. Carries no width of its own -- the parent grid's
      # `grid-auto-columns` (see `GanttComponent#column_grid_style`) sizes
      # every cell uniformly, so appending/prepending one is nothing more
      # than inserting a plain DOM node. Standalone (like `ItemComponent`,
      # unlike `RowComponent`/its items) for the same reason `ItemComponent`
      # is -- a `next_dates_path`/`prev_dates_path` Turbo Stream response has
      # to `append`/`prepend` *new* header cells into `#{id}_dates` alongside
      # the new bars it backfills into existing rows (see `GanttComponent`'s
      # class docs, "Loading more days"), and it needs something it can
      # render for just those new dates without re-rendering the whole grid.
      #
      #   render(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: new_date, today: Date.current))
      class DateHeaderComponent < AtomicView::Component
        attr_reader :date, :today

        # @param date [Date] the day this column represents.
        # @param today [Date, nil] highlights this cell when given and equal
        #   to `date`.
        def initialize(date:, today: nil, **options)
          super()
          @date = date
          @today = today
          @options = options
        end

        def html_options
          @options.except(:class)
        end

        def html_class
          class_names(base_classes, {"text-primary" => today?}, @options[:class])
        end

        def today?
          today.present? && date.to_date == today.to_date
        end

        def primary_label
          date.day.to_s
        end

        def secondary_label
          date.strftime("%a")
        end

        private

        def base_classes
          "sticky top-0 z-10 flex flex-col items-center justify-center gap-0.5 border-b border-border bg-surface py-2 text-xs font-semibold text-muted-foreground"
        end
      end
    end
  end
end
