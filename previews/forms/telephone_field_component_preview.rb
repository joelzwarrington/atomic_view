module Forms
  class TelephoneFieldComponentPreview < Lookbook::Preview
    # Telephone field
    # ---------------
    # Renders `<input type="tel">`. It doesn't validate format — phone
    # number formats vary too much across countries — but it does trigger
    # a numeric-friendly mobile keyboard. Use it for phone numbers; pair
    # it with your own format validation/masking if you need one.
    #
    # @param label text "The field's label"
    # @param placeholder text
    # @param required toggle
    # @param disabled toggle
    def default(label: "Phone number", placeholder: "(555) 555-5555", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder, required: required, disabled: disabled})
    end
  end
end
