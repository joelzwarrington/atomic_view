# frozen_string_literal: true

module AtomicView
  module Components
    class TableComponent
      # TableComponent::Row
      #
      # A single <tr>, renderable standalone -- no parent TableComponent
      # instance required. That matters because a turbo_stream
      # `append`/`update` response renders exactly one row outside of any
      # table context, e.g.:
      #
      #   turbo_stream.append(:bookings_body, AtomicView::Components::TableComponent::RowComponent.new(
      #     record: @booking, label: @booking.camper_name, path: booking_path(@booking)
      #   ) { |row| row.with_cell { @booking.camper_name } })
      #
      # `path` defaults to `record` itself so `path_to(record)`-style route
      # helpers resolve it via `to_model`/`to_param` the same way `link_to`
      # would; pass `path:` explicitly when the row's destination isn't
      # just `record`'s own show page.
      #
      # Each `with_cell` becomes its own stretched link to `path` -- a
      # single `<a>` can't span multiple `<td>` siblings the way it could
      # wrap a `<div>` row -- but only the first cell's link stays in the
      # tab order (`tabindex="0"`; the rest are `tabindex="-1"` and
      # `aria-hidden`), so a keyboard/screen-reader user hits one focus
      # stop per row rather than one per cell. `label` is that first
      # link's accessible name. Pass `clickable: false` for a row that
      # shouldn't navigate anywhere -- cells then render as plain,
      # unlinked content.
      class RowComponent < AtomicView::Component
        renders_many :cells, ->(**kwargs) { CellComponent.new(path: path, label: label, first: cells.empty?, clickable: clickable, **kwargs) }

        attr_reader :record, :label, :path, :clickable

        def initialize(record:, label:, path: nil, clickable: true, **options)
          super()
          @record = record
          @label = label
          @path = path || record
          @clickable = clickable
          @options = options
        end

        def html_class
          class_names(clickable ? "hover:bg-offset" : nil, @options[:class])
        end

        def html_options
          @options.except(:class)
        end
      end
    end
  end
end
