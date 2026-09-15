# frozen_string_literal: true

module AtomicView
  module Components
    # Table
    #
    # A thin styling wrapper around <table>. By default this owns no
    # row/column concept -- the consuming view builds its own
    # <thead>/<tbody> markup and calls the yielded component's #head_class
    # / #row_class helpers to pick up the shared styling:
    #
    #   <%= render AtomicView::Components::TableComponent.new do |table| %>
    #     <thead>
    #       <tr class="<%= table.head_class %>">
    #         <th class="px-3 py-2">Name</th>
    #       </tr>
    #     </thead>
    #     <tbody>
    #       <tr class="<%= table.row_class %>">
    #         <td class="px-3 py-2">Riverbend</td>
    #       </tr>
    #     </tbody>
    #   <% end %>
    #
    # `with_column` is an opt-in alternative to hand-building the <thead>:
    # give it at least one column and TableComponent renders the header row
    # itself, from `<th>`s built by TableComponent::ColumnComponent -- and
    # wraps the block's return value in a <tbody> for you too, so the block
    # only has to render rows (typically TableComponent::RowComponent),
    # same as it would for a turbo_stream append/update elsewhere:
    #
    #   <%= render AtomicView::Components::TableComponent.new(model: Booking) do |table| %>
    #     <% table.with_column(attribute: :camper_name) %>
    #     <% table.with_column(attribute: :status, align: :center) %>
    #     <% table.with_column(label: "") %>
    #
    #     <% @bookings.each do |booking| %>
    #       <%= render(AtomicView::Components::TableComponent::RowComponent.new(record: booking, label: booking.camper_name, path: booking_path(booking))) do |row| %>
    #         <% row.with_cell { booking.camper_name } %>
    #         <% row.with_cell(align: :center) { render(BadgeComponent.new) { booking.status } } %>
    #         <% row.with_cell(interactive: true) { render(LinkComponent.new(edit_booking_path(booking), variant: :outline)) { "Edit" } } %>
    #       <% end %>
    #     <% end %>
    #   <% end %>
    #
    # The <tbody>'s `id` defaults to `model.model_name.plural` (e.g.
    # "bookings") so a turbo_stream response can target it directly with
    # no extra bookkeeping -- pass `body_id:` to override it (a nested
    # resource sharing a differently-named frame, say).
    #
    # A table with no columns given renders exactly as before -- `with_column`
    # is opt-in, not a second required API, and in that raw mode you still
    # own the whole `<thead>`/`<tbody>` yourself. `model:` is passed through
    # to each column so `with_column(attribute: :camper_name)` can default
    # its label via `model.human_attribute_name(:camper_name)`; a column
    # with no backing attribute (like the blank "" header above, for an
    # actions column) just passes `label:` directly instead.
    class TableComponent < AtomicView::Component
      HEAD_ROW_CLASSES = "text-left text-xs font-semibold uppercase tracking-wide text-muted-foreground border-b border-border"
      BODY_ROW_CLASSES = "border-b border-border hover:bg-offset"

      renders_many :columns, ->(**kwargs) { ColumnComponent.new(model: model, **kwargs) }

      attr_reader :model

      def initialize(model: nil, body_id: nil, **options)
        super()
        @model = model
        @body_id = body_id
        @options = options
      end

      def call
        tag.table(**@options.except(:class), class: class_names(base_classes, @options[:class])) do
          if columns?
            safe_join([columns_header, tag.tbody(content, id: body_id)])
          else
            content
          end
        end
      end

      def head_class(**options)
        class_names(HEAD_ROW_CLASSES, options[:class])
      end

      def row_class(**options)
        class_names(BODY_ROW_CLASSES, options[:class])
      end

      private

      def columns_header
        return unless columns?
        tag.thead { tag.tr(class: head_class) { safe_join(columns) } }
      end

      def columns?
        columns.any?
      end

      def body_id
        @body_id || model&.model_name&.plural
      end

      def base_classes
        "w-full text-sm"
      end
    end
  end
end
