module Forms
  class MonthFieldComponentPreview < Lookbook::Preview
    # Month field
    # -----------
    # Renders `<input type="month">`, a native month/year picker. It's
    # faster to fill than `date_select`'s three dropdowns, but the picker
    # UI varies across browsers. Use it when only the month and year
    # matter (e.g. a card expiration date, a billing period).
    #
    # @param label text "The field's label"
    # @param required toggle
    # @param disabled toggle
    def default(label: "Expiration month", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, required: required, disabled: disabled})
    end
  end
end
