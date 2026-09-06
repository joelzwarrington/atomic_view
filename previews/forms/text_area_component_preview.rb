module Forms
  class TextAreaComponentPreview < Lookbook::Preview
    # Text area
    # ---------
    # Renders a multi-line `<textarea>` that grows to fit its content
    # vertically. Use it for free-form text longer than a line or two —
    # descriptions, comments, notes — and a plain `text_field` for
    # anything shorter.
    #
    # @param label text "The field's label"
    # @param placeholder text
    # @param required toggle
    # @param disabled toggle
    def default(label: "Notes", placeholder: "Anything the front desk should know...", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder, required: required, disabled: disabled})
    end
  end
end
