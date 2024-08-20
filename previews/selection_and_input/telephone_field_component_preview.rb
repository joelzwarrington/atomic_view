module SelectionAndInput
  class TelephoneFieldComponentPreview < Lookbook::Preview
    def default
      render_with_template locals: {model: Model.new}
    end
  end
end
