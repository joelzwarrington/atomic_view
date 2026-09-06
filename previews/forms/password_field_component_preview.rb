module Forms
  class PasswordFieldComponentPreview < Lookbook::Preview
    # Password field
    # --------------
    # Renders `<input type="password">`, masking the entered value on
    # screen. Rails also excludes password fields from request logs by
    # default (`config.filter_parameters`). Use it for passwords, secrets,
    # or anything else that shouldn't be visible while typing.
    #
    # @param label text "The field's label"
    # @param placeholder text
    # @param required toggle
    # @param disabled toggle
    def default(label: "Password", placeholder: nil, required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, placeholder: placeholder, required: required, disabled: disabled})
    end
  end
end
