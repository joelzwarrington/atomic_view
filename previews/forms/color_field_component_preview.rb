module Forms
  class ColorFieldComponentPreview < Lookbook::Preview
    # Color field
    # -----------
    # Renders a native color-picker swatch (`<input type="color">`). Use
    # it for picking an actual color value (a tag color, a theme accent) —
    # not as a general-purpose "click to open a panel" control.
    #
    # @param label text "The field's label"
    # @param disabled toggle
    def default(label: "Tag color", disabled: false)
      render_with_template(locals: {model: AtomicView::Model.new, label: label, disabled: disabled})
    end
  end
end
