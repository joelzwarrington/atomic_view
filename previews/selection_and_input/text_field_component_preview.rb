module SelectionAndInput
  class TextFieldComponentPreview < Lookbook::Preview
    def default
      model = AtomicView::Model.new
      model.errors.add :attribute, :blank, message: "can't be blank"
      render_with_template locals: {model: model}
    end
  end
end
