module Forms
  class GroupedCollectionSelectComponentPreview < Lookbook::Preview
    # Grouped collection select
    # -------------------------
    # A dropdown built from a collection of groups, each with its own
    # sub-collection of options, rendered as native `<optgroup>`s. Use it
    # when the options are naturally categorized (e.g. campsites grouped
    # by park) and the grouping helps the user scan the list.
    #
    # @param label text "The field's label"
    def default(label: "Site")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end
  end
end
