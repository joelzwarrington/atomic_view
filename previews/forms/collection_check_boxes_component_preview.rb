module Forms
  class CollectionCheckBoxesComponentPreview < Lookbook::Preview
    # Collection check boxes
    # -----------------------
    # Renders one check box per item in a collection, all bound to the
    # same (array-valued) attribute — use it for "choose any number of
    # these" selections generated from data, rather than hand-writing a
    # `check_box` per option.
    #
    # @param label text "The field's legend"
    def default(label: "Amenities")
      render_with_template(locals: {model: AtomicView::Model.new, label: label})
    end
  end
end
