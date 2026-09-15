module Display
  class LazyPaginationComponentPreview < Lookbook::Preview
    # LazyPagination
    # --------------
    # The infinite-scroll counterpart to `PaginationComponent`'s
    # page-number links -- pair it with `IndexPageComponent#with_pagination`
    # for a list that loads its next page automatically as the user
    # scrolls, instead of paging through numbered links. This preview has
    # no backend to fetch from (same as `GanttComponent`'s preview), so
    # the loading frame below won't actually resolve -- in a real app,
    # `next_page_path` points at a controller action that responds with a
    # Turbo Stream `append`ing the next batch of rows plus a
    # `replace(:pagination, ...)` for this frame itself.
    #
    # @param has_next_page toggle
    def default(has_next_page: true)
      render(AtomicView::Components::LazyPaginationComponent.new(
        next_page: has_next_page ? 2 : nil,
        next_page_path: has_next_page ? "/bookings?page=2" : nil
      ))
    end
  end
end
