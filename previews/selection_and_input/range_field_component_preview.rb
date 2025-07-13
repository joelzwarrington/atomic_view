module SelectionAndInput
  class RangeFieldComponentPreview < Lookbook::Preview
    def default
      render_with_template locals: {model: AtomicView::Model.new}
    end
  end
end
