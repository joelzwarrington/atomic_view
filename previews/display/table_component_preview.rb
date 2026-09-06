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
  end
end
