module Layout
  class PageHeaderComponentPreview < Lookbook::Preview
    # Index-page header
    # ------------------
    # The plain title + actions shape used at the top of a collection page —
    # no breadcrumb (there's nowhere "up" from an index page) and no badge,
    # just a title, an optional subtitle for a record count, and a cluster of
    # actions on the opposite side of the row.
    def index_style
      render_with_template
    end

    # Show-page header
    # -----------------
    # Every slot filled: a breadcrumb link back to the index, a title, an
    # inline status badge, a subtitle line (here a reference id), and two
    # actions. This is the full header from a record's detail page.
    def show_style
      render_with_template
    end

    # Title only
    # ----------
    # Every other slot is optional — only `title` is expected to be filled.
    def minimal
      render(AtomicView::Components::PageHeaderComponent.new) do |header|
        header.with_title { "Parks" }
      end
    end
  end
end
