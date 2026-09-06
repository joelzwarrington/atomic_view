module Forms
  class WeekFieldComponentPreview < Lookbook::Preview
    # Week field
    # ----------
    # Renders `<input type="week">`, a native ISO week/year picker (e.g.
    # "2026-W07"). Use it when the domain concept is a calendar week
    # rather than a specific day — a weekly report period, a shift
    # schedule.
    #
    # @param label text "The field's label"
    # @param required toggle
    # @param disabled toggle
    def default(label: "Reporting week", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, required: required, disabled: disabled})
    end
  end
end
