# frozen_string_literal: true

module AtomicView
  module Components
    # Pagination
    #
    # Plain <a href> pagination -- no JS/Turbo/AJAX. `path_for_page` is a
    # Proc/lambda supplied by the consumer (e.g. ->(page) { parks_path(page: page) })
    # so this component stays router/pagination-gem agnostic.
    #
    # The prev/next control on a boundary (page 1's "Previous", the last
    # page's "Next") renders as a <span> rather than a link, since there is
    # no page to navigate to and a "disabled" <a href> would still be
    # clickable/focusable in most browsers -- a plain non-interactive span is
    # the simpler, unambiguous option.
    class PaginationComponent < AtomicView::Component
      include AtomicView::Components::Concerns::ButtonVariants

      attr_reader :current_page, :total_pages, :path_for_page

      def initialize(current_page:, total_pages:, path_for_page:)
        super()
        @current_page = current_page
        @total_pages = total_pages
        @path_for_page = path_for_page
      end

      def page_numbers
        (1..total_pages).to_a
      end

      def first_page?
        current_page <= 1
      end

      def last_page?
        current_page >= total_pages
      end

      def path_for(page)
        path_for_page.call(page)
      end

      def control_classes
        class_names(base_classes, variant_classes)
      end

      def disabled_control_classes
        class_names(control_classes, "pointer-events-none opacity-50")
      end

      def page_link_classes(page)
        class_names(page_base_classes, (page == current_page) ? active_page_classes : inactive_page_classes)
      end

      def page_link_attributes(page)
        attributes = {class: page_link_classes(page)}
        attributes[:"aria-current"] = "page" if page == current_page
        attributes
      end

      private

      def variant
        :outline
      end

      def page_base_classes
        "flex size-7 items-center justify-center rounded-btn text-sm font-medium"
      end

      def active_page_classes
        "bg-secondary text-secondary-foreground"
      end

      def inactive_page_classes
        "text-muted-foreground hover:bg-offset"
      end
    end
  end
end
