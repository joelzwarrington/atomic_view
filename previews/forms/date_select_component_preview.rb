module Forms
  class DateSelectComponentPreview < Lookbook::Preview
    # Date select
    # -----------
    # Renders a day/month/year trio of native `<select>` dropdowns. It
    # looks identical in every browser (unlike `date_field`'s native
    # picker), at the cost of being slower to fill in and less
    # mobile-friendly. Prefer `date_field` unless cross-browser visual
    # consistency matters more than input speed.
    #
    # @param label text "The field's label"
    def default(label: "Date of birth")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end
  end
end
