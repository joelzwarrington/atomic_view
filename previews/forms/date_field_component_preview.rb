module Forms
  class DateFieldComponentPreview < Lookbook::Preview
    # Date field
    # ----------
    # Renders `<input type="date">`, a native single-day picker. It's
    # quicker to fill and more mobile-friendly than `date_select`'s three
    # dropdowns, at the cost of a picker UI that varies across browsers.
    # Use it as the default for a plain date; reach for `date_select` when
    # you need identical rendering everywhere.
    #
    # @param label text "The field's label"
    # @param required toggle
    # @param disabled toggle
    def default(label: "Arrival date", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, required: required, disabled: disabled})
    end
  end
end
