# frozen_string_literal: true

module AtomicView
  module Components
    class TableComponent
      # TableComponent::Cell
      #
      # One <td> within a RowComponent -- see that class's docs for the
      # standalone-render requirement and the per-cell stretched-link
      # design. `first` and `clickable` are set by RowComponent's `cells`
      # slot from the row itself, not passed by the caller.
      #
      # Visible content renders as a sibling of the (empty, transparent)
      # stretched `<a>`, wrapped in a `pointer-events-none` span so plain
      # content (the common case -- a name, a badge) doesn't sit in the
      # way of clicks meant for the row-wide overlay underneath it. Pass
      # `interactive: true` on a cell that renders a real, more specific
      # link/button of its own (e.g. an "Edit" action) to flip that span
      # back to `pointer-events-auto`, so that cell's own content takes
      # the click instead of falling through to the row link.
      class CellComponent < AtomicView::Component
        attr_reader :path, :label, :first, :align, :clickable, :interactive

        def initialize(path:, label:, first:, align: :left, clickable: true, interactive: false, **options)
          super()
          @path = path
          @label = label
          @first = first
          @align = align
          @clickable = clickable
          @interactive = interactive
          @options = options
        end

        def linked?
          clickable && path.present?
        end

        def html_class
          class_names(base_classes, align_classes, @options[:class])
        end

        def html_options
          @options.except(:class)
        end

        def content_class
          interactive ? "relative pointer-events-auto" : "relative pointer-events-none"
        end

        private

        def base_classes
          "relative px-2.5 py-2.5 border-b border-border/5"
        end

        def align_classes
          case align
          when :center then "text-center font-semibold"
          when :right then "text-right"
          end
        end
      end
    end
  end
end
