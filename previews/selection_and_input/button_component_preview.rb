module SelectionAndInput
  class ButtonComponentPreview < ViewComponent::Preview
    def default
      binding.irb
      render_with_template locals: {model: Model.new}
    end
  end
end
