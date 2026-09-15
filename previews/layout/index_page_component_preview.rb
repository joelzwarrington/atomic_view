module Layout
  class IndexPageComponentPreview < Lookbook::Preview
    # Full layout
    # -----------
    # Every region filled in: header (title + count subtitle + actions), a
    # `filters` row of status pills, a `toolbar` row, a table as the default
    # content, and `pagination`. Like PageComponent, this component owns
    # layout only — it never references TableComponent itself; the table in
    # this example is just what the caller chose to render into the content
    # region.
    def default
      render_with_template(locals: {model: AtomicView::Model.new})
    end

    # Empty
    # -----
    # When `empty:` is true, the `empty_state` slot renders instead of the
    # default content block, and `pagination` is suppressed even if given.
    def empty
      render_with_template
    end
  end
end
