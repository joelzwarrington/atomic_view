module Display
  class PaginationComponentPreview < Lookbook::Preview
    # Pagination
    # ----------
    # Plain `<a href>` pagination — no JS/Turbo/AJAX. You supply
    # `path_for_page` (a lambda) so this stays router/pagination-gem
    # agnostic; wire it to whatever generates your index URLs, e.g.
    # `->(page) { parks_path(page: page) }`.
    #
    # The "Previous"/"Next" control renders as plain (non-clickable) text
    # on a boundary page rather than a disabled-looking link, since a
    # `disabled` `<a>` would still be focusable/clickable in most browsers.
    #
    # @param current_page number
    # @param total_pages number
    def default(current_page: 1, total_pages: 5)
      render(AtomicView::Components::PaginationComponent.new(
        current_page: current_page,
        total_pages: total_pages,
        path_for_page: ->(page) { "/parks?page=#{page}" }
      ))
    end
  end
end
