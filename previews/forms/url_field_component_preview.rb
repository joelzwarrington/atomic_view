module Forms
  class UrlFieldComponentPreview < Lookbook::Preview
    # URL field
    # ---------
    # Renders `<input type="url">`. Browsers validate that the value looks
    # like a URL and show a URL-optimized mobile keyboard (with quick
    # access to "/" and ".com"). Use it for website/link inputs.
    #
    # @param label text "The field's label"
    # @param placeholder text
    # @param required toggle
    # @param disabled toggle
    def default(label: "Website", placeholder: "https://example.com", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder, required: required, disabled: disabled})
    end
  end
end
