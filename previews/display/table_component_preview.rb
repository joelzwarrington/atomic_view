module Display
  class TableComponentPreview < Lookbook::Preview
    # Table
    # -----
    # A thin styling wrapper around `<table>` — it doesn't own row/column
    # iteration or data fetching. Build your own `<thead>`/`<tbody>`
    # markup in the block and call the yielded `table.head_class` /
    # `table.row_class` to pick up the shared header/row styling. Use it
    # for any tabular list of records; reach for `CardComponent` instead
    # when each record needs a richer, non-tabular layout.
    def default
      render_with_template
    end

    # With columns and rows
    # ----------------------
    # The opt-in, model-aware alternative to hand-building `<thead>`/
    # `<tbody>`: give `TableComponent` a `model:` and one or more
    # `with_column`s and it renders the header row itself (label defaults
    # from `model.human_attribute_name`) and wraps your rows in a `<tbody>`
    # keyed by the model's plural name. Rows use
    # `TableComponent::RowComponent` -- every `with_cell` becomes its own
    # stretched link back to `path`, so the whole row is clickable, but
    # only the first cell's link stays in the tab order. A column with no
    # backing attribute (the blank header over the "Edit" links) just
    # passes `label:` directly instead. Cells default to
    # `pointer-events-none` on their content so plain text doesn't shadow
    # the row-wide link -- the "Edit" cell passes `interactive: true` since
    # it renders a real link of its own that needs to win the click.
    def with_columns
      render_with_template(locals: {bookings: bookings})
    end

    private

    def bookings
      [
        Booking.new(camper_name: "Karen Wilson", status: "active"),
        Booking.new(camper_name: "Jordan Lee", status: "pending"),
        Booking.new(camper_name: "Sam Patel", status: "active")
      ]
    end
  end
end
