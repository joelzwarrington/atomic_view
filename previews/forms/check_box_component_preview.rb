module Forms
  class CheckBoxComponentPreview < Lookbook::Preview
    # Check box
    # ---------
    # A single boolean toggle bound to one attribute — "on" or "off",
    # nothing in between. Use `collection_check_boxes` instead when the
    # user is choosing zero or more options from a set.
    #
    # @param label text "The check box's label"
    # @param checked toggle
    # @param disabled toggle
    def default(label: "Send me email updates", checked: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, checked: checked, disabled: disabled})
    end
  end
end
