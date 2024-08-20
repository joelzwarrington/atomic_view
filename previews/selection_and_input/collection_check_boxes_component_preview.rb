module SelectionAndInput
  class CollectionCheckBoxesComponentPreview < Lookbook::Preview
    def default
      render_with_template locals: {model: Model.new}
    end
  end
end
