# frozen_string_literal: true

module AtomicView
  module Components
    # LazyPagination
    #
    # The infinite-scroll counterpart to PaginationComponent's page-number
    # links -- use PaginationComponent for numbered pages, this one for a
    # list that loads its next page automatically as the user scrolls.
    # Stays equally pagination-gem agnostic: the caller resolves both
    # `next_page` (any presence-checkable value, e.g. a Pagy `next` page
    # number) and `next_page_path` (the URL that lazily loaded page comes
    # from) themselves.
    #
    #   render(AtomicView::Components::LazyPaginationComponent.new(
    #     next_page: @pagy.next,
    #     next_page_path: @pagy.next && bookings_path(page: @pagy.next)
    #   ))
    #
    # Renders a `<turbo-frame loading="lazy" src="...">` (the same
    # `tag.turbo_frame` technique GanttComponent's row/date pagination
    # uses -- see that class's docs -- rather than a hard dependency on
    # turbo-rails' view helpers) wrapping a spinner while `next_page` is
    # present. Once there's no next page, it renders an empty
    # `<turbo-frame>` with the same `id` instead of nothing at all, so a
    # later `turbo_stream.replace(id, ...)` response from the last real
    # page's fetch always has a target to replace.
    class LazyPaginationComponent < AtomicView::Component
      attr_reader :next_page, :next_page_path, :id

      def initialize(next_page:, next_page_path: nil, id: :pagination)
        super()
        @next_page = next_page
        @next_page_path = next_page_path
        @id = id
      end

      def next_page?
        next_page.present?
      end
    end
  end
end
