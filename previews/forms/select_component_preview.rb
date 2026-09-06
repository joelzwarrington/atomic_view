module Forms
  class SelectComponentPreview < Lookbook::Preview
    # @!group Examples

    # Default
    # -------
    # A dropdown built from a static list of `[label, value]` pairs — use
    # it for a small, fixed set of choices known at development time.
    # Reach for `collection_select` instead when the options come from a
    # collection of records/objects.
    #
    # @param label text "The field's label"
    def default(label: "Category")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end

    # With a leading icon
    # -------------------
    # Pass `left_section` for a plain, non-interactive icon inside the
    # select, same as on a text field.
    #
    # @param label text "The field's label"
    def with_left_icon(label: "Category")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end

    # With a leading addon
    # --------------------
    # Set `left_section_as_addon: true` to fuse a bordered label segment
    # (e.g. "Type") to the front of the select.
    #
    # @param label text "The field's label"
    def with_left_addon(label: "Category")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end

    # With a trailing icon
    # --------------------
    # The same non-interactive icon treatment on the right side.
    #
    # @param label text "The field's label"
    def with_right_icon(label: "Category")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end

    # @!endgroup
  end
end
