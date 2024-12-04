module SelectionAndInput
  class TextFieldComponentPreview < Lookbook::Preview
    def default
      render_with_template locals: {model: Model.new}
    end

    def with_validation_error
      model = Model.new
      model.errors.add :attribute, :blank, message: "can't be blank"
      render_with_template locals: {model: model}
    end

    # @!group "With sections"
    def with_left_section
      render_with_template locals: {model: Model.new}
    end

    def with_left_section_addon
      render_with_template locals: {model: Model.new}
    end

    def with_left_section_interaction
      render_with_template locals: {model: Model.new}
    end

    def with_right_section
      render_with_template locals: {model: Model.new}
    end

    def with_right_section_addon
      render_with_template locals: {model: Model.new}
    end

    def with_right_section_interaction
      render_with_template locals: {model: Model.new}
    end
    # @!endgroup
  end
end
