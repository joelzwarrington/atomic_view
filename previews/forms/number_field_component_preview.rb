module Forms
  class NumberFieldComponentPreview < Lookbook::Preview
    # Number field
    # ------------
    # Renders `<input type="number">` with a spinner control and a numeric
    # mobile keyboard. Use `min`/`max`/`step` to constrain the range.
    # Prefer `range_field` instead when the value's position matters more
    # than typing an exact number.
    #
    # @param label text "The field's label"
    # @param placeholder text
    # @param required toggle
    # @param disabled toggle
    def default(label: "Quantity", placeholder: "1", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder, required: required, disabled: disabled})
    end
  end
end
