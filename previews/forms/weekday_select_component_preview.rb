module Forms
  class WeekdaySelectComponentPreview < Lookbook::Preview
    # Weekday select
    # --------------
    # A dropdown of the seven weekdays, generated for you — use it for
    # "which day of the week" choices (a recurring schedule, a delivery
    # day) without hand-building the options list yourself.
    #
    # @param label text "The field's label"
    def default(label: "Cleaning day")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end
  end
end
