module Forms
  class CollectionSelectComponentPreview < Lookbook::Preview
    # @!group Examples

    # Default
    # -------
    # A dropdown built from a collection of records/objects (via a value
    # method and a text method), rather than a hardcoded list of pairs.
    # Use it whenever the options come from the database or another
    # collection at render time — reach for plain `select` instead for a
    # small, fixed set of choices.
    #
    # @param label text "The field's label"
    def default(label: "Camper")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end

    # With a leading icon
    # -------------------
    # Same non-interactive icon treatment as the base `select`/`text_field`
    # components.
    #
    # @param label text "The field's label"
    def with_left_icon(label: "Camper")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end

    # With a leading addon
    # --------------------
    # Fuses a bordered label segment to the front of the select via
    # `left_section_as_addon: true`.
    #
    # @param label text "The field's label"
    def with_left_addon(label: "Camper")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end

    # @!endgroup
  end
end
