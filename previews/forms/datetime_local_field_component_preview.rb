module Forms
  class DatetimeLocalFieldComponentPreview < Lookbook::Preview
    # Datetime-local field
    # --------------------
    # Renders `<input type="datetime-local">`, a native combined
    # date-and-time picker with no timezone conversion (the value is
    # exactly what's shown). Use it for scheduling an event in the
    # viewer's own local time — reach for `datetime_select` instead if you
    # need consistent segmented-dropdown styling across all browsers.
    #
    # @param label text "The field's label"
    # @param required toggle
    # @param disabled toggle
    def default(label: "Check-in time", required: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, required: required, disabled: disabled})
    end
  end
end
