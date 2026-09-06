module Forms
  class TimeZoneSelectComponentPreview < Lookbook::Preview
    # Time zone select
    # ----------------
    # A dropdown of Rails' recognized time zones (`ActiveSupport::TimeZone`),
    # grouped by UTC offset. Use it wherever a user needs to pick their own
    # time zone — account settings, scheduling a call — rather than
    # building a time zone list by hand.
    #
    # @param label text "The field's label"
    def default(label: "Time zone")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end
  end
end
