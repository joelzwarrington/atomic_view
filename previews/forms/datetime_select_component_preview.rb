module Forms
  class DatetimeSelectComponentPreview < Lookbook::Preview
    # Datetime select
    # ---------------
    # The `date_select` segmented-dropdown treatment extended to include
    # hour and minute. Prefer `datetime_local_field`'s native picker
    # unless you need identical rendering across every browser.
    #
    # @param label text "The field's label"
    def default(label: "Appointment time")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end
  end
end
