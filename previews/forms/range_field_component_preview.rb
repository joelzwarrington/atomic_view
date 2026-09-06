module Forms
  class RangeFieldComponentPreview < Lookbook::Preview
    # Range field
    # -----------
    # Renders `<input type="range">` (a slider). Use it when the visual
    # position along a range matters more than the precisely typed
    # number — a volume control, a fuzzy price range. Prefer
    # `number_field` when the exact value matters and users need to type
    # or fine-tune it with a keyboard.
    #
    # @param label text "The field's label"
    # @param disabled toggle
    def default(label: "Search radius", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, disabled: disabled})
    end
  end
end
