module Forms
  class CollectionRadioButtonsComponentPreview < Lookbook::Preview
    # Collection radio buttons
    # ------------------------
    # Renders one radio button per item in a collection, all bound to the
    # same attribute — use it for "choose exactly one of these"
    # selections generated from data, rather than hand-writing a
    # `radio_button` per option.
    #
    # @param label text "The field's legend"
    def default(label: "Site type")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end
  end
end
