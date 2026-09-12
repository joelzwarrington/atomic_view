# frozen_string_literal: true

module AtomicView
  module Components
    class GanttComponent
      # A single date column header cell within a `GanttComponent`'s
      # `#{id}_dates` strip. Standalone (like `ItemComponent`, unlike
      # `RowComponent`/its items) for the same reason `ItemComponent` is --
      # a `next_dates_path`/`prev_dates_path` Turbo Stream response has to
      # `append`/`prepend` *new* header cells into `#{id}_dates` alongside
      # the new bars it backfills into existing rows (see `GanttComponent`'s
      # class docs, "Loading more days"), and it needs something it can
      # render for just those new dates without re-rendering the whole grid.
      #
      #   render(AtomicView::Components::GanttComponent::DateHeaderComponent.new(date: new_date, cell_width: @cell_width, scale: @scale, today: Date.current))
      #
      # `cell_width:`/`scale:`/`today:` should all match whatever the parent
      # `GanttComponent` was given -- same requirement as `RowComponent`/
      # `ItemComponent`'s equivalents, see `GanttComponent`'s class docs.
      class DateHeaderComponent < AtomicView::Component
        attr_reader :date, :cell_width, :scale, :today

        # @param date [Date] the date this column represents -- the day
        #   itself at `:day` scale, or the first day of the week/month at
        #   `:week`/`:month` scale.
        # @param cell_width [Integer] must match the parent `GanttComponent`'s.
        # @param scale [Symbol] must match the parent `GanttComponent`'s --
        #   changes both label formatting and what "today" means here (the
        #   whole week/month `date` falls within, not just an exact match).
        # @param today [Date, nil] highlights this cell when given and
        #   `date` falls in the same day/week/month as it.
        def initialize(date:, cell_width: GanttComponent::DEFAULT_CELL_WIDTH, scale: GanttComponent::DEFAULT_SCALE, today: nil, **options)
          super()
          @date = date
          @cell_width = cell_width
          @scale = scale.to_sym
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
          today.present? && GanttComponent.period_start(date, scale: scale) == GanttComponent.period_start(today, scale: scale)
        end

        def primary_label
          case scale
          when :week, :month
            date.strftime("%b %-d")
          else
            date.day.to_s
          end
        end

        def secondary_label
          case scale
          when :week
            "Week"
          when :month
            date.strftime("%Y")
          else
            date.strftime("%a")
          end
        end

        private

        def base_classes
          "sticky top-0 z-10 flex flex-none flex-col items-center justify-center gap-0.5 border-b border-border bg-surface py-2 text-xs font-semibold text-muted-foreground"
        end
      end
    end
  end
end
