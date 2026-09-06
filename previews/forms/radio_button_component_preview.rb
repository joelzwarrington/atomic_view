module Forms
  class RadioButtonComponentPreview < Lookbook::Preview
    # Radio button
    # ------------
    # One option in a set of mutually-exclusive choices sharing the same
    # attribute — selecting one deselects the others. Use
    # `collection_radio_buttons` instead when the options come from a
    # collection/array rather than being hand-written one at a time.
    #
    # @param label text "The radio button's label"
    # @param checked toggle
    # @param disabled toggle
    def default(label: "Standard shipping", checked: false, disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, checked: checked, disabled: disabled})
    end
  end
end
