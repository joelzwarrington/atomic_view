module Forms
  class EmailFieldComponentPreview < Lookbook::Preview
    # Email field
    # -----------
    # Renders `<input type="email">`. Browsers validate that the typed
    # value looks like an email address and show an email-optimized
    # keyboard on mobile. Use it for any email address input instead of a
    # plain `text_field`.
    #
    # @param label text "The field's label"
    # @param placeholder text
    # @param required toggle
    # @param disabled toggle
    def default(label: "Email address", placeholder: "jane@example.com", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder, required: required, disabled: disabled})
    end
  end
end
