module Forms
  class LabelComponentPreview < Lookbook::Preview
    # @!group Variants

    # Default
    # -------
    # The standard field label — use it above (or beside) every form input
    # so the field has an accessible, visible name. This is what
    # `form.label` renders unless you opt into a variant.
    #
    # @param content text "The label text"
    def default(content: "Email address")
      render_with_template(locals: {model: AtomicView::Model.new, content: content})
    end

    # Caption
    # -------
    # A small, uppercase, muted label style — use it as a heading over a
    # `fieldset` grouping related fields, not as a replacement for an
    # individual field's own label (each field inside the group still
    # gets its own default-variant label).
    #
    # @param content text "The section heading text"
    def caption(content: "Account details")
      render_with_template(locals: {model: AtomicView::Model.new, content: content})
    end

    # @!endgroup
  end
end
