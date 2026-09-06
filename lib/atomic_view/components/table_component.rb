# frozen_string_literal: true

module AtomicView
  module Components
    # Table
    #
    # A thin styling wrapper around <table>. Consistent with the rest of the
    # gem, this does not own row/column iteration -- the consuming view
    # builds its own <thead>/<tbody> markup and calls the yielded component's
    # #head_class / #row_class helpers to pick up the shared styling.
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
    class TableComponent < AtomicView::Component
      HEAD_ROW_CLASSES = "text-left text-xs font-semibold uppercase tracking-wide text-muted-foreground border-b border-border"
      BODY_ROW_CLASSES = "border-b border-border hover:bg-offset"

      def initialize(**options)
        super()
        @options = options
      end

      def call
        tag.table(**@options.except(:class), class: class_names(base_classes, @options[:class])) { content }
      end

      def head_class(**options)
        class_names(HEAD_ROW_CLASSES, options[:class])
      end

      def row_class(**options)
        class_names(BODY_ROW_CLASSES, options[:class])
      end

      private

      def base_classes
        "w-full text-sm"
      end
    end
  end
end
