module Forms
  class TimeSelectComponentPreview < Lookbook::Preview
    # Time select
    # -----------
    # An hour/minute (and optionally second) trio of native `<select>`
    # dropdowns, with no date component. Use it when only a time-of-day
    # matters (opening hours, a daily reminder time) and you want
    # consistent rendering across browsers.
    #
    # @param label text "The field's label"
    def default(label: "Opening time")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end
  end
end
