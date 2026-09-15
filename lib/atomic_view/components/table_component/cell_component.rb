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
      # Visible content renders as a normal sibling of the (empty,
      # transparent) stretched `<a>`, wrapped in its own `position:
      # relative` span so a real link nested inside a cell's content (e.g.
      # a second, more specific action) still stays clickable above the
      # row-wide overlay.
      class CellComponent < AtomicView::Component
        attr_reader :path, :label, :first, :align, :clickable

        def initialize(path:, label:, first:, align: :left, clickable: true, **options)
          super()
          @path = path
          @label = label
          @first = first
          @align = align
          @clickable = clickable
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
